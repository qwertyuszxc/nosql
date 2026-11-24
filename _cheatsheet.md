# Шпаргалка: NoSQL, Kolokwium 1

## ⚠️ Мои ловушки (проверять ПЕРЕД сдачей каждого задания)
1. **SQL:** `;` после КАЖДОГО запроса · строки в **'одинарных'** · при `SERIAL` **не пишу id** в INSERT
2. **Redis:** перечитать команду **по буквам** · `unknown command` / `(nil)` / `0` = опечатка или чужой тип · `ZADD` **заменяет**, `ZINCRBY` **прибавляет**
3. **JSON Schema:** `required` и `additionalProperties` — **РЯДОМ** с `properties`, не внутри · удалил последнее поле → убрать запятую
4. **XSD:** атрибут — внутри `complexType` **своего** элемента, ПОСЛЕ его `</xs:sequence>` · `maxOccurs="unbounded"` — на **повторяющийся** элемент (`speaker`), не на контейнер
5. **Вопрос словами → ответ словами** в комментарии (`--` в SQL, `#` в Redis-файле)

---

## PostgreSQL
```sql
SELECT col, COUNT(*) AS n, ROUND(AVG(price), 2) AS avg_p
FROM t
WHERE (a = 'x' OR a = 'y') AND year >= 2015   -- скобки вокруг OR!
GROUP BY col
HAVING COUNT(*) >= 3                           -- условие на ГРУППУ
ORDER BY avg_p DESC
LIMIT 3;
```
- `IN ('a','b')` · `BETWEEN 1 AND 8` (включительно) · `ILIKE '%man%'` (без регистра) · **`IS NULL`** (не `= NULL`!)
- JOIN: `FROM a JOIN b ON b.a_id = a.id JOIN c ON ...`

```sql
DROP TABLE IF EXISTS child, parent;            -- сначала тот, кто ссылается
CREATE TABLE t (
  id       SERIAL PRIMARY KEY,
  name     VARCHAR(50) NOT NULL UNIQUE,
  qty      INT NOT NULL CHECK (qty BETWEEN 1 AND 5),
  flag     BOOLEAN DEFAULT true,
  other_id INT REFERENCES other(id) ON DELETE CASCADE
);
INSERT INTO t (name, qty, other_id) VALUES ('a', 1, 2), ('b', 3, 1);

CREATE VIEW v AS SELECT ... ;    -- в SELECT ВСЕ столбцы, по которым потом фильтрую
SELECT * FROM v WHERE city = 'Krakow';
```
Ошибки ограничений: `violates unique constraint` · `violates check constraint` · `violates foreign key constraint` · `violates not-null constraint`

**SQL vs NoSQL:** жёсткая схема vs гибкая · vertical (мощнее сервер) vs horizontal (больше серверов) · strong vs flexible consistency

---

## Redis
Подключение: `docker exec -it redis_lab redis-cli` · загрузка: `Get-Content file.txt | docker exec -i redis_lab redis-cli`

| Тип | Команды |
|---|---|
| **string** | `SET k v` · `GET k` · `MSET k1 v1 k2 v2` · `MGET k1 k2` (полные имена!) · `INCR` `INCRBY k 5` `DECR` `DECRBY k 5` · `SETNX k v` (только если нет → 1/0) · `SET k v NX` |
| **hash** | `HSET h f1 v1 f2 v2` (создать/обновить/добавить) · `HGET h f` · `HMGET h f1 f2` · `HGETALL h` · `HKEYS h` · `HVALS h` · `HINCRBY h f 1` · `HDEL h f` |
| **list** | `LPUSH`/`RPUSH q v` · `LPOP`/`RPOP q` (удаляет!) · `LRANGE q 0 -1` (только смотрит) · `LLEN q` · **FIFO = LPUSH + RPOP** |
| **set** | `SADD s a b` · `SMEMBERS s` · `SISMEMBER s a` (1/0) · `SREM s a` · `SCARD s` · `SINTER a b` (оба) · `SUNION a b` (всё) · `SDIFF a b` (в a, не в b) |
| **zset** | `ZADD z 100 m` (**заменяет**) · `ZINCRBY z 50 m` (**прибавляет**) · `ZSCORE z m` · `ZRANGE z 0 2 WITHSCORES` (меньшие) · `ZREVRANGE z 0 2 WITHSCORES` (топ) · `ZRANK`/`ZREVRANK z m` (**с 0**) · `ZCOUNT z min max` (включ.) · `ZRANGEBYSCORE z min max` · **`ZREVRANGEBYSCORE z MAX MIN`** · `ZREM z m` |
| **любой** | `KEYS user:*` · `EXISTS k` · `DEL k` · `TYPE k` · `EXPIRE k 30` (только таймер) · `SET k v EX 60` · `TTL k` · `PERSIST k` |

- `TTL`: число = секунд осталось · **-1** = есть, без таймера · **-2** = ключа нет
- `SET` по существующему ключу **сбрасывает TTL**; продлить без изменения значения → `EXPIRE`
- Значение с пробелами — в **"кавычках"**
- **SETNX vs EXISTS+SET:** атомарность (нет race condition)
- **RDB** = снимки (быстрое восстановление, можно потерять данные) · **AOF** = журнал команд (надёжнее)
- `KEYS *` блокирует сервер → на продакшене `SCAN`

---

## JSON
- Строки и ключи только в **"двойных"** кавычках · `true/false/null` маленькими · без висячих запятых · одна корневая `{}`/`[]` · дробь через точку `457.00`
- `null` без кавычек

## JSON Schema
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id":    { "type": "string", "pattern": "^EVT-[0-9]{4}-[0-9]{2}$" },
    "title": { "type": "string", "minLength": 3 },
    "price": { "type": "number", "minimum": 0.01 },
    "unit":  { "type": "number", "exclusiveMinimum": 0 },
    "qty":   { "type": "integer", "minimum": 1 },
    "cat":   { "type": "string", "enum": ["a", "b"] },
    "email": { "type": "string", "format": "email" },
    "date":  { "type": "string", "format": "date" },
    "grade": { "type": ["number", "null"] },
    "obj": {
      "type": "object",
      "properties": { "name": { "type": "string" } },
      "required": ["name"]
    },
    "items": {
      "type": "array", "minItems": 1,
      "items": { "type": "object", "properties": { }, "required": [ ] }
    },
    "tags": { "type": "array", "minItems": 1, "items": { "type": "string" } }
  },
  "required": ["id", "title"],
  "additionalProperties": false
}
```
- **http**, не https · по умолчанию лишние поля **РАЗРЕШЕНЫ**
- Привязка данных: `"$schema": "./schema.json"`. Если в схеме `additionalProperties: false`, сам `$schema` станет ошибкой → удалить перед сдачей или разрешить `"$schema": {"type":"string"}`
- Данные не проходят → правлю **данные**, не схему

---

## XML
- Один корень · теги закрыты · правильная вложенность `<a><b></b></a>` · **регистр важен** · атрибуты в **"кавычках"** · `&` → `&amp;` (`<` → `&lt;`)
- **well-formed** = синтаксис правильный · **valid** = соответствует схеме
- Нет `null` → необязательный элемент просто отсутствует (`minOccurs="0"`)
- Атрибут = метаданные (`id`, код), элемент = данные и всё вложенное/списки

## XSD
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="order">                       <!-- корень через xs:element -->
    <xs:complexType>
      <xs:sequence>                               <!-- строгий порядок; xs:all — любой -->
        <xs:element name="id" type="xs:string"/>
        <xs:element name="title">
          <xs:simpleType><xs:restriction base="xs:string">
            <xs:minLength value="3"/>             <!-- pattern / enumeration / minInclusive / minExclusive -->
          </xs:restriction></xs:simpleType>
        </xs:element>
        <xs:element name="items">
          <xs:complexType><xs:sequence>
            <xs:element name="item" maxOccurs="unbounded">   <!-- 1..∞ -->
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="qty" type="xs:positiveInteger"/>
                </xs:sequence>
                <xs:attribute name="type" use="required">    <!-- ПОСЛЕ sequence -->
                  <xs:simpleType><xs:restriction base="xs:string">
                    <xs:enumeration value="a"/><xs:enumeration value="b"/>
                  </xs:restriction></xs:simpleType>
                </xs:attribute>
              </xs:complexType>
            </xs:element>
          </xs:sequence></xs:complexType>
        </xs:element>
        <xs:element name="note" type="xs:string" minOccurs="0"/>  <!-- необязательный -->
      </xs:sequence>
      <xs:attribute name="code" type="xs:integer" use="required"/>
    </xs:complexType>
  </xs:element>
</xs:schema>
```
- Типы: `xs:string` `xs:integer` `xs:decimal` `xs:boolean` (только `true/false/1/0`) `xs:date` (`2026-12-05`) `xs:positiveInteger` (≥1) `xs:nonNegativeInteger` (≥0)
- Ограничения: `minLength` `maxLength` `pattern` (без `^$`, всегда вся строка) `enumeration` `minInclusive` (≥) `minExclusive` (>) `maxInclusive`
- По умолчанию `minOccurs=1 maxOccurs=1` · атрибут по умолчанию **необязательный** → `use="required"`
- XSD по умолчанию **ЗАКРЫТ**: лишний элемент/атрибут = ошибка (разрешить: `xs:any` / `xs:anyAttribute`)
- Email в XSD встроенного нет → `xs:pattern`
- Привязка XML: `<root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="schema.xsd">`
