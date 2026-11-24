# Пробный коллоквиум: NoSQL, Kolokwium 1

**Время: 75 минут. Максимум 10 баллов.**

Правила:
- Засеки время. Начни с темы, в которой уверен больше всего.
- Без интернета и без моих подсказок. Можно пользоваться слайдами (`_*.md`) и своими решениями: на настоящем коллоквиуме, скорее всего, будет так же.
- Ответы пиши в файлы в папке `mock/` (список ниже). Когда закончишь или выйдет время, напиши «проверь коллоквиум».

| Часть | Баллы | Ориентировочное время |
|---|---|---|
| A. PostgreSQL | 3.0 | 25 мин |
| B. Redis | 3.0 | 20 мин |
| C. JSON | 2.0 | 15 мин |
| D. XML | 2.0 | 15 мин |

Файлы для ответов:
- `answers.sql`: часть A
- `answers_redis.txt`: часть B
- `event.json` (исправить на месте) и `event_schema.json`: часть C
- `event.xml` (исправить на месте) и `event_schema.xsd`: часть D

---

## Part A: PostgreSQL (3 points)

Run `library.sql` to create and populate a library database (`members`, `books`, `loans`).
A loan with `return_date = NULL` has **not been returned yet**.

**A1 (0.5 pts).** List the `title`, `author` and `year` of all **Fantasy** and **Sci-Fi** books published in **2015 or later**, from the newest to the oldest.

**A2 (0.5 pts).** For each genre, show the number of books and the average price rounded to 2 decimal places. Show only genres with **at least 3 books**, ordered by average price from highest to lowest.

**A3 (1 pt).** Create a table `reviews`:
- `id`: auto-incrementing primary key
- `book_id`: foreign key to `books(id)`; when a book is deleted, its reviews must be deleted automatically
- `member_id`: foreign key to `members(id)`, same deletion rule
- `rating`: required integer from 1 to 5 (inclusive)
- `comment`: optional text

Then:
1. Insert **3 valid** reviews (any books and members).
2. Write **2 INSERTs that must fail**: one violating the rating rule, and one referencing a **book that does not exist**. In a comment, write which constraint stopped each of them.
3. Delete the book `'Dune'` and show that its reviews disappeared. Make sure at least one of your reviews in step 1 is for Dune.

**A4 (1 pt).** Create a view `v_open_loans` showing, for every loan that has **not been returned yet**: the member's `full_name`, the member's `city`, the book `title` and the `loan_date`.

Using **only the view**:
1. Show the open loans of members from **Krakow**, oldest loan first.
2. Show members who have **more than one** open loan, together with the number of their open loans.

---

## Part B: Redis (3 points)

Load the data (from the `mock` folder):
```powershell
Get-Content cinema.txt | docker exec -i redis_lab redis-cli
```
Write every command in `answers_redis.txt`.

**B1. Strings (0.5 pts)**
1. Display the cinema name stored in `config:cinema_name`.
2. A customer bought 3 tickets: increase `stats:tickets_sold_today` by 3 **and** decrease `seats:hall1:free` by 3, using atomic operations.

**B2. Hashes (0.5 pts)**
1. Read **only** the `title` and `duration` of `movie:101` using **a single command**.
2. Change the `rating` of `movie:103` to `7.1` **and** add a new field `language` with value `"EN"`, using **a single command**.
3. Display all **values** of `movie:102` without the field names.

**B3. Lists (0.5 pts)**
Orders in `queue:orders` are processed in FIFO order (they were added with `LPUSH`).
1. Display all orders without removing them.
2. Process (take and remove) the **oldest** order.
3. Add the order `"order_504: 1x Wicked"` so that it is processed **last**.
4. Display the number of orders still in the queue.

**B4. Sets (0.5 pts)**
1. Show the movies watched by **both** `user:1` and `user:2` (keys `watched:user:1`, `watched:user:2`).
2. Show the movies watched by `user:1` but **not** by `user:2`.
3. Check whether `user:2` has watched `"movie:101"`.

**B5. Sorted sets (0.5 pts)**
The key `ranking:weekly` stores the number of tickets sold this week per movie.
1. Show the **top 3** movies with their scores (highest first).
2. Show the position of `"Wicked"` in the ranking, where position 0 is the best-selling movie.
3. `"Barbie"` sold 150 more tickets. Update its score atomically.
4. List all movies (with scores) that sold **between 600 and 1000** tickets (inclusive), from highest to lowest. Is Barbie in the result after step 3? Answer in a comment.

**B6. Expiration and conditional writes (0.5 pts)**
1. Check how many seconds remain for `session:user:1`.
2. Extend the session so it stays valid for 300 seconds from now, **without changing its value**.
3. Set `config:maintenance` to `"on"` **only if the key does not exist yet**.
4. Remove the expiration from `session:user:1` so it never expires. What does `TTL` return now? Answer in a comment.

---

## Part C: JSON (2 points)

**C1 (0.5 pts).** `event.json` contains several syntax errors. Fix all of them **in place** without losing any data, then format the file properly.

**C2 (1.5 pts).** Create `event_schema.json` (JSON Schema, draft-07) that validates `event.json`:
- `eventId`: string in the format `EVT-YYYY-NN`, e.g. `EVT-2026-01` (four digits, dash, two digits)
- `title`: string, at least 5 characters
- `date`: string in date format (e.g. `2026-12-05`)
- `online`: boolean
- `venue`: object with `name` and `city` (both strings, both required)
- `tickets`: array with **at least one** ticket. Each ticket is an object with:
  - `type`: one of `"standard"`, `"vip"`, `"student"`
  - `price`: number, **0 or more** (student tickets may be free)
  - `available`: integer, 0 or more
  - all three fields required
- `speakers`: **optional** array of strings with at least one element
- Required at root level: `eventId`, `title`, `date`, `venue`, `tickets`
- **No other properties** are allowed at root level.

Validate `event.json` against your schema. If validation fails because of the data, fix **the data**, not the schema. In a comment in your answer, or in the chat, explain what you changed and why.

---

## Part D: XML (2 points)

**D1 (0.5 pts).** `event.xml` is **not well-formed**. Fix all errors **in place**. Do not lose any data: everything currently in the file must stay in the document.

**D2 (1.5 pts).** Create `event_schema.xsd` that validates the fixed `event.xml`:
- Root element `<event>` with:
  - required attribute `id` (string)
  - optional attribute `online` (boolean)
- Child elements in this order:
  - `<title>`: string, at least 5 characters
  - `<date>`: a date (use the XSD date type)
  - `<venue>` with `<name>` and `<city>`
  - `<tickets>` with **one or more** `<ticket>` elements. Each `<ticket>` has:
    - a **required attribute** `type` with one of the values `standard`, `vip`, `student`
    - `<price>`: decimal, 0 or more
    - `<available>`: non-negative integer
  - `<speakers>`: **optional**, containing one or more `<speaker>` (string)
  - `<note>`: **optional** string
- Link `event.xml` to the schema and check in VS Code that it validates.
- Verify that changing one ticket to `type="premium"` causes a validation error.

---

## Bonus theory questions (0 points, for self-check)
1. What is the difference between **well-formed** and **valid** XML?
2. By default, does JSON Schema allow properties not listed in `properties`? And XSD?
3. Why use `SETNX` instead of `EXISTS` followed by `SET`?
4. Name the two Redis persistence mechanisms and one advantage of each.
5. SQL vs NoSQL: what is the difference between vertical and horizontal scaling?
