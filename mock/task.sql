select title, author, year from books
where (genre = 'Fantasy' or genre = 'Sci-Fi') and year >= 2015
ORDER BY year DESC;

select count(*) , round(avg(price),2), genre from books
GROUP BY genre
HAVING count(*) >= 3
ORDER BY avg(price) DESC;

CREATE Table reviews(
    id SERIAL PRIMARY KEY,
    book_id int REFERENCES books(id) 
    on delete CASCADE,
    member_id int REFERENCES members(id)
    on delete CASCADE,
    rating int not null check(rating between 1 and 5),
    comment VARCHAR
);

insert INTO reviews(book_id, member_id, rating)
VALUES (1,1,4.0),
(2,2,3.0),
(4,2,2.0);



insert INTO reviews(book_id, member_id, rating)
VALUES (4,4,6);

insert INTO reviews(book_id, member_id, rating)
VALUES (20,4,5);

delete from books WHERE title = 'Dune';
select * from reviews;


CREATE View v_open_loans AS
select m.full_name, m.city, b.title, l.loan_date from loans l
join members m on m.id = l.member_id
join books b on b.id = l.book_id
WHERE l.return_date is null;

select * from v_open_loans
where city = 'Krakow'
ORDER BY loan_date;

select full_name, count(*) from v_open_loans
GROUP BY full_name
having count(*) > 1;








