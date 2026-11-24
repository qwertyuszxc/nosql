select first_name, last_name, department, salary from employees
where department = 'Engineering' and is_remote = true and salary > 80000;

select * from employees
where hire_date BETWEEN '2021-01-01' and '2022-12-31'
ORDER BY hire_date;

select * from employees
where job_title like '%Manager%';

SELECT * from employees
order by salary DESC
limit 3;

select count(id), avg(salary) from employees;

select count(*), department,avg(salary) from employees
GROUP BY department;

select department, avg(salary) from employees
GROUP BY department
having avg(salary) > 80000;


--TASK 2
CREATE Table rooms (
    id serial primary key,
    room_name VARCHAR(50) NOT NULL UNIQUE,
    capacity int check(capacity>0),
    has_projector BOOLEAN DEFAULT(true)
);

create table users(
    id serial PRIMARY KEY,
    full_name VARCHAR(100) not null,
    email VARCHAR(100) UNIQUE not NULL
);

create table bookings(
    id SERIAL PRIMARY KEY,
    room_id int REFERENCES rooms(id) on delete CASCADE,
    user_id int REFERENCES users(id) on delete CASCADE,
    booking_date DATE not NULL,
    duration_hours INT check (duration_hours >= 1 and duration_hours <= 8)
);


-- Insert Rooms
INSERT INTO rooms (room_name, capacity, has_projector) VALUES
('Boardroom A', 12, true),
('Focus Room B', 4, false),
('Auditorium C', 50, true);

-- Insert Users
INSERT INTO users (full_name, email) VALUES
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Smith', 'bob.smith@example.com'),
('Charlie Brown', 'charlie.brown@example.com');

-- Insert Bookings
INSERT INTO bookings (room_id, user_id, booking_date, duration_hours) VALUES
(1, 1, '2026-09-20', 2), -- Alice booked Boardroom A
(1, 2, '2026-09-21', 4), -- Bob booked Boardroom A
(2, 1, '2026-09-22', 1), -- Alice booked Focus Room B
(3, 3, '2026-09-20', 3); -- Charlie booked Auditorium C


select u.full_name, r.room_name, b.duration_hours, b.booking_date from bookings b
join users u on b.user_id = u.id
join rooms r on b.room_id = r.id;



-- Delete user 'Alice Johnson'
DELETE FROM users WHERE email = 'alice.johnson@example.com';

-- Verify that Alice's bookings were automatically removed from the bookings table
SELECT * FROM bookings;


select c.full_name, c.country, o.id, o.order_date from customers c
join orders o on o.customer_id = c.id
where o.status = 'COMPLETED';

select sum(oi.quantity * oi.unit_price) as item_totals, c.full_name from order_items oi
join orders o on o.id = oi.order_id
join customers c on c.id = o.customer_id
where o.status = 'COMPLETED'
GROUP BY c.full_name
HAVING sum(oi.quantity * oi.unit_price) > 300;

CREATE VIEW v_customer_revenue AS
SELECT sum(oi.quantity * oi.unit_price) as item_totals, c.country, c.full_name from order_items oi
join orders o on o.id = oi.order_id
join customers c on c.id = o.customer_id
where o.status = 'COMPLETED'
GROUP BY c.full_name, c.country


SELECT * FROM v_customer_revenue WHERE country = 'USA';
