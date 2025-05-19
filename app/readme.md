####

####
Flask==3.0.2
#### DB enteris
DROP TABLE IF EXISTS bookmarks;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories (id)
);

INSERT INTO categories (name) VALUES ('Technology');
INSERT INTO categories (name) VALUES ('News');
INSERT INTO categories (name) VALUES ('Personal');

INSERT INTO bookmarks (title, url, category_id) VALUES ('Flask Documentation', 'https://flask.palletsprojects.com/en/2.3.x/', 1);
INSERT INTO bookmarks (title, url, category_id) VALUES ('BBC News', 'https://www.bbc.com/news', 2);
INSERT INTO bookmarks (title, url, category_id) VALUES ('My Blog', 'https://your-blog.com', 3);
### Prompt
Write a Python3 flask code of bookmarks app with distinct categories and with sqlite3 backend with features like add, modify and remove bookmarks
