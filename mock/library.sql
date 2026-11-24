-- Mock colloquium: Library database
DROP TABLE IF EXISTS reviews, loans, books, members CASCADE;
DROP VIEW IF EXISTS v_open_loans;

CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    joined DATE NOT NULL
);

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(30) NOT NULL,
    year INT NOT NULL,
    price NUMERIC(6, 2) CHECK (price > 0)
);

CREATE TABLE loans (
    id SERIAL PRIMARY KEY,
    member_id INT REFERENCES members(id) ON DELETE CASCADE,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    loan_date DATE NOT NULL,
    return_date DATE
);

INSERT INTO members (full_name, city, joined) VALUES
('Anna Nowak', 'Krakow', '2022-02-10'),
('Piotr Zielinski', 'Warsaw', '2021-09-01'),
('Maria Wisniewska', 'Krakow', '2023-05-17'),
('Jan Kowalczyk', 'Gdansk', '2020-11-23'),
('Ewa Lewandowska', 'Warsaw', '2024-01-08'),
('Tomasz Wojcik', 'Krakow', '2019-06-30');

INSERT INTO books (title, author, genre, year, price) VALUES
('The Witcher: Blood of Elves', 'Andrzej Sapkowski', 'Fantasy', 1994, 39.90),
('Project Hail Mary', 'Andy Weir', 'Sci-Fi', 2021, 49.00),
('The Fifth Season', 'N. K. Jemisin', 'Fantasy', 2015, 42.50),
('Dune', 'Frank Herbert', 'Sci-Fi', 1965, 35.00),
('Murder on the Orient Express', 'Agatha Christie', 'Crime', 1934, 29.99),
('The Three-Body Problem', 'Liu Cixin', 'Sci-Fi', 2014, 45.00),
('Klara and the Sun', 'Kazuo Ishiguro', 'Sci-Fi', 2021, 52.00),
('The Name of the Wind', 'Patrick Rothfuss', 'Fantasy', 2007, 44.90),
('Gone Girl', 'Gillian Flynn', 'Crime', 2012, 34.50),
('Pride and Prejudice', 'Jane Austen', 'Classic', 1813, 19.99),
('Piranesi', 'Susanna Clarke', 'Fantasy', 2020, 47.00),
('The Silent Patient', 'Alex Michaelides', 'Crime', 2019, 38.00);

INSERT INTO loans (member_id, book_id, loan_date, return_date) VALUES
(1, 2, '2026-09-01', '2026-09-20'),
(1, 11, '2026-10-15', NULL),
(1, 6, '2026-11-02', NULL),
(2, 4, '2026-08-10', '2026-08-30'),
(2, 9, '2026-11-05', NULL),
(3, 1, '2026-10-01', '2026-10-21'),
(3, 3, '2026-11-10', NULL),
(4, 5, '2026-09-12', '2026-10-01'),
(4, 12, '2026-10-20', NULL),
(4, 8, '2026-11-01', NULL),
(5, 7, '2026-11-15', NULL),
(6, 10, '2026-07-07', '2026-07-28'),
(6, 2, '2026-10-25', NULL);

SELECT 'library loaded' AS status;
