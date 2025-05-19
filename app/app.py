####
from flask import Flask, render_template, request, redirect, url_for
import sqlite3

app = Flask(__name__)
DATABASE = 'bookmarks.db'

def get_db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row  # Return rows as dictionaries
    return conn

def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

@app.cli.command('initdb')
def initdb_command():
    """Initializes the database."""
    init_db()
    print('Initialized the database.')

def query_db(query, args=(), one=False):
    conn = get_db()
    cur = conn.execute(query, args)
    rv = cur.fetchall()
    cur.close()
    conn.close()
    return (rv[0] if rv else None) if one else rv

def execute_db(query, args=()):
    conn = get_db()
    cur = conn.execute(query, args)
    conn.commit()
    cur.close()
    conn.close()

@app.route('/')
def index():
    bookmarks = query_db('SELECT b.id, b.title, b.url, c.name AS category_name FROM bookmarks b JOIN categories c ON b.category_id = c.id ORDER BY c.name, b.title')
    categories = query_db('SELECT id, name FROM categories ORDER BY name')
    return render_template('index.html', bookmarks=bookmarks, categories=categories)

@app.route('/category/<int:category_id>')
def view_category(category_id):
    category = query_db('SELECT id, name FROM categories WHERE id = ?', [category_id], one=True)
    if not category:
        return render_template('error.html', message='Category not found.')
    bookmarks = query_db('SELECT id, title, url FROM bookmarks WHERE category_id = ? ORDER BY title', [category_id])
    categories = query_db('SELECT id, name FROM categories ORDER BY name')
    return render_template('category.html', category=category, bookmarks=bookmarks, categories=categories)

@app.route('/add', methods=['GET', 'POST'])
def add_bookmark():
    categories = query_db('SELECT id, name FROM categories ORDER BY name')
    if request.method == 'POST':
        title = request.form['title']
        url = request.form['url']
        category_id = request.form['category_id']
        if title and url and category_id:
            execute_db('INSERT INTO bookmarks (title, url, category_id) VALUES (?, ?, ?)', [title, url, category_id])
            return redirect(url_for('index'))
        else:
            return render_template('add.html', categories=categories, error='All fields are required.')
    return render_template('add.html', categories=categories)

@app.route('/modify/<int:bookmark_id>', methods=['GET', 'POST'])
def modify_bookmark(bookmark_id):
    bookmark = query_db('SELECT id, title, url, category_id FROM bookmarks WHERE id = ?', [bookmark_id], one=True)
    categories = query_db('SELECT id, name FROM categories ORDER BY name')
    if not bookmark:
        return render_template('error.html', message='Bookmark not found.')

    if request.method == 'POST':
        title = request.form['title']
        url = request.form['url']
        category_id = request.form['category_id']
        if title and url and category_id:
            execute_db('UPDATE bookmarks SET title = ?, url = ?, category_id = ? WHERE id = ?', [title, url, category_id, bookmark_id])
            return redirect(url_for('index'))
        else:
            return render_template('modify.html', bookmark=bookmark, categories=categories, error='All fields are required.')
    return render_template('modify.html', bookmark=bookmark, categories=categories)

@app.route('/remove/<int:bookmark_id>')
def remove_bookmark(bookmark_id):
    bookmark = query_db('SELECT id, title FROM bookmarks WHERE id = ?', [bookmark_id], one=True)
    if not bookmark:
        return render_template('error.html', message='Bookmark not found.')
    execute_db('DELETE FROM bookmarks WHERE id = ?', [bookmark_id])
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
