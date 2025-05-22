CREATE TABLE Reader
(
    id            SERIAL PRIMARY KEY,
    full_name     VARCHAR(100)        NOT NULL,
    gender        VARCHAR(10) CHECK (gender IN ('male', 'female')),
    email         VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE                NOT NULL
);
-- Таблица Book
CREATE TABLE Book
(
    id             SERIAL PRIMARY KEY,
    book_name      VARCHAR(100) NOT NULL,
    genre          VARCHAR(50),
    published_year INT,
    price          NUMERIC(10, 2),
    is_booked      BOOLEAN DEFAULT false
);
-- Таблица Author
CREATE TABLE Author
(
    id        SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender    VARCHAR(10) CHECK (gender IN ('male', 'female')),
    book_id   INT REFERENCES Book (id)
);
-- Таблица Library
CREATE TABLE Library
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    book_id   INT REFERENCES Book (id),
    reader_id INT REFERENCES Reader (id)
);
-- Readers
INSERT INTO Reader (full_name, gender, email, date_of_birth)
VALUES ('Elnura Arapova', 'female', 'elnura@gmail.com', '2002-05-20'),
       ('Sanjar Suanbekov', 'male', 'sanjar@gmail.com', '1995-03-14'),
       ('Chyngyz Zalkarbekov', 'male', 'chyngyz@gmail.com', '1999-10-30'),
       ('Symbat Salyamov', 'male', 'symbat@gmail.com', '1990-11-11'),
       ('Fatima Altynbek kyzy', 'female', 'fati@gmail.com', '2001-07-22'),
       ('Baitenir Busurmanov', 'male', 'baitenir@gmail.com', '1988-01-05'),
       ('Sanjar Orozobekov', 'male', 'sanjar.o@gmail.com', '1994-06-09'),
       ('Nurpazyl Nabiev', 'male', 'nurpazyl@gmail.com', '1998-02-14'),
       ('Junusbek Abdurahmanov', 'male', 'junus@gmail.com', '2004-01-14'),
       ('Abdulkudus Imarov', 'male', 'abdu@gmail.com', '1998-12-14'),
       ('Artur Rakhmanov', 'male', 'artur@gmail.com', '2000-09-04');
-- Books
INSERT INTO Book (book_name, genre, published_year, price, is_booked)
VALUES ('War and Peace', 'Historical', 1869, 1500.00, true),         -- 1
       ('Harry Potter', 'Fantasy', 2001, 900.00, false),             -- 2
       ('Clean Code', 'Programming', 2008, 1200.00, true),           -- 3
       ('1984', 'Dystopian', 1949, 800.00, false),                   -- 4
       ('Python Crash Course', 'Programming', 2016, 1300.00, false), -- 5
       ('The Great Gatsby', 'Classic', 1925, 950.00, true),          -- 6
       ('The Hobbit', 'Fantasy', 1937, 1000.00, false),              -- 7
       ('Sapiens', 'History', 2011, 1600.00, true);
-- 8
-- Authors
INSERT INTO Author (full_name, gender, book_id)
VALUES ('Leo Tolstoy', 'male', 1),
       ('J.K. Rowling', 'female', 2),
       ('Robert C. Martin', 'male', 3),
       ('George Orwell', 'male', 4),
       ('Eric Matthes', 'male', 5),
       ('F. Scott Fitzgerald', 'male', 6),
       ('J.R.R. Tolkien', 'male', 7),
       ('Yuval Noah Harari', 'male', 8);
-- Libraries
INSERT INTO Library (name, book_id, reader_id)
VALUES ('Central Library', 1, 1),
       ('Youth Library', 2, 2),
       ('Tech Library', 3, 3),
       ('City Library', 4, 4),
       ('IT Library', 5, 5),
       ('Classic Library', 6, 6),
       ('Children Library', 7, 7),
       ('Historical Library', 8, 8),
       ('Central Library', 2, 9),
       ('Tech Library', 5, 10),
       ('Youth Library', 6, 11),
       ('City Library', 1, 2);
-- 1
SELECT *
FROM Library;

-- 2
SELECT *
FROM Library l
         JOIN Reader r
              ON l.reader_id = r.id
WHERE gender = 'male';

-- 3
SELECT l.name, COUNT(book_id) AS books_count
FROM library l
         JOIN book b
              ON l.book_id = b.id
GROUP BY name;

-- 4
SELECT library.name AS library_name, book.book_name AS book_name
FROM library
         JOIN book
              ON library.book_id = book.id;

-- 5
SELECT l.name      AS library_name,
       r.full_name AS reader_name
FROM library l
         JOIN reader r
              ON l.reader_id = r.id;

-- 7
SELECT *
FROM library l
         JOIN book b
              ON l.book_id = b.id
WHERE is_booked = 'true';

-- 8
SELECT *
FROM library l
         JOIN reader r
              ON L.reader_id = R.id
WHERE gender = 'female';

-- 9
SELECT *
FROM library l
         JOIN reader r
              ON l.reader_id = r.id;

-- 10
SELECT *
FROM library
         JOIN book
              ON library.book_id = book.id
WHERE price > 1000;

-- todo reader tasks:
-- 1.Получить всех читателей
SELECT *
FROM reader;

-- 2. Читатели и библиотеки, где они зарегистрированы:
SELECT r.full_name, l.name
FROM reader r
         JOIN library l
              ON l.reader_id = r.id;

-- 3. Читатели и названия книг, которые они читают
SELECT r.full_name AS readers_name,
       l.name      AS books_name
FROM reader r
         JOIN Library l ON r.id = l.reader_id;

-- 4. Получить читателей и книги, которые они читают
SELECT r.full_name AS reader_name,
       b.book_name AS book_name
FROM library l
         JOIN reader r ON l.reader_id = r.id
         JOIN book b ON l.book_id = b.id;

-- 5. Читатели и авторы прочитанных книг
SELECT r.full_name AS readers_name,
       a.full_name AS authors_name
FROM library l
         JOIN book b ON l.book_id = b.id
         JOIN author a ON A.book_id = b.id
         JOIN reader r ON r.id = l.reader_id;

-- 6. Вывести читателей, читающих определённый жанр
SELECT r.full_name AS reader_name,
       b.genre     AS book_genre
FROM library l
         JOIN reader r ON l.reader_id = r.id
         JOIN book b ON l.book_id = b.id;

-- 7. Получить всех читателей, читающих книги, изданные после 2010
SELECT r.full_name AS reader_name,
       b.book_name
FROM library l
         JOIN reader r ON l.reader_id = r.id
         JOIN book b ON l.book_id = b.id
WHERE b.published_year > 2010;

-- 8. Найти читателей, у которых книги написаны женщинами
SELECT r.full_name AS reader_name,
       b.book_name
FROM library l
         JOIN reader r ON l.reader_id = r.id
         JOIN book b ON l.book_id = b.id
         JOIN author a ON a.book_id = b.id
WHERE a.gender = 'female';

-- todo book requests:
-- 1.Получить все книги
SELECT *
FROM book;

-- 2. Книги и библиотеки, где они находятся
SELECT b.book_name,
       l.name AS library_name
FROM library l
         JOIN book b ON l.book_id = b.id;

-- 3. Получить книги и авторы
SELECT b.book_name,
       a.full_name AS author_name
FROM book b
         JOIN author a ON a.book_id = b.id;

-- 4. Получить книги и читатели
SELECT b.book_name,
       r.full_name AS reader_name
FROM library l
         JOIN book b ON l.book_id = b.id
         JOIN reader r ON l.reader_id = r.id;

-- 5. Книги, изданные после 2010 года
SELECT *
FROM book
WHERE published_year > 2010;

-- 6. Книги с определенным жанром
SELECT book_name, book.genre
FROM book;

-- 7. Книги, которые забронированы
SELECT *
FROM book
WHERE is_booked = 'true';

-- 8. Количество книг по жанрам
SELECT genre, COUNT(*)
FROM Book
GROUP BY genre;

-- 9. Книга и библиотека, отсортированные по цене
SELECT b.book_name,
       l.name AS library_name,
       b.price
FROM library l
         JOIN book b ON l.book_id = b.id
ORDER BY b.price;

-- todo author queries:
-- 1.Все авторы
SELECT *
FROM Author;

-- 2. Авторы и их книги
SELECT a.full_name AS author_name,
       b.book_name
FROM author a
         JOIN book b ON a.book_id = b.id;

-- 3.Авторы и библиотеки
SELECT a.full_name AS author_name,
       l.name      AS library_name
FROM author a
         JOIN book b ON a.book_id = b.id
         JOIN library l ON b.id = l.book_id;

-- 4. Авторы и читатели
SELECT a.full_name AS author_name,
       r.full_name AS reader_name
FROM author a
         JOIN book b ON a.book_id = b.id
         JOIN library l ON b.id = l.book_id
         JOIN reader r ON l.reader_id = r.id;

-- 5. Авторы без книг
SELECT a.full_name AS author_name
FROM author a
WHERE book_id IS NULL;

-- 6. Авторы, у которых книги не забронированы
SELECT *
FROM Author a
         JOIN Book b
              ON a.book_id = b.id
WHERE b.is_booked = 'false';

-- 7. Авторы, написавшие книги в жанре "Programming"
SELECT *
FROM Author a
         JOIN book b
              ON a.book_id = b.id
WHERE genre = 'Programming';

-- 8. Отсортировать авторов по алфавиту
SELECT *
FROM Author
ORDER BY full_name;

-- 9. Книга и библиотека, отсортированные по цене
SELECT b.price,
       b.book_name,
       l.name AS library_name
FROM library l
         JOIN book b
              ON l.book_id = b.id
ORDER BY price;







