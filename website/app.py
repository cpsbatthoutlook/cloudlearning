import sqlite3
from flask import Flask, render_template, request, redirect, url_for, g

# --- Flask Application Setup ---
app = Flask(__name__)
app.config['DATABASE'] = 'bookmarks.db' # SQLite database file

# --- Database Helper Functions ---

def get_db():
    """
    Establishes a new database connection if one doesn't exist for the current request.
    """
    if 'db' not in g:
        g.db = sqlite3.connect(
            app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row # Allows accessing columns by name
    return g.db

def close_db(e=None):
    """
    Closes the database connection at the end of the request.
    """
    db = g.pop('db', None)
    if db is not None:
        db.close()

def init_db():
    """
    Initializes the database schema.
    This function should be called once to create the table.
    """
    with app.app_context():
        db = get_db()
        # Create the bookmarks table if it doesn't exist
        db.execute('''
            CREATE TABLE IF NOT EXISTS bookmarks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                url TEXT NOT NULL,
                category TEXT NOT NULL,
                description TEXT
            )
        ''')
        db.commit()
    print("Database initialized successfully.")

# Register the close_db function to be called when the app context tears down
app.teardown_appcontext(close_db)

# --- Routes ---

@app.route('/', methods=['GET', 'POST'])
def index():
    """
    Handles displaying bookmarks and adding new ones.
    GET: Displays all bookmarks, optionally filtered by category.
    POST: Adds a new bookmark to the database.
    """
    db = get_db()
    cursor = db.cursor()

    # Get distinct categories for the filter dropdown
    cursor.execute("SELECT DISTINCT category FROM bookmarks ORDER BY category")
    categories = [row['category'] for row in cursor.fetchall()]

    selected_category = request.args.get('category')
    query = "SELECT * FROM bookmarks"
    params = []

    if selected_category and selected_category != 'All':
        query += " WHERE category = ?"
        params.append(selected_category)

    query += " ORDER BY category, title"
    cursor.execute(query, params)
    bookmarks = cursor.fetchall()

    if request.method == 'POST':
        # Add new bookmark
        title = request.form['title'].strip()
        url = request.form['url'].strip()
        category = request.form['category'].strip()
        description = request.form.get('description', '').strip()

        if not title or not url or not category:
            # Basic validation
            # In a real app, you'd show an error message to the user
            print("Error: Title, URL, and Category are required.")
            return redirect(url_for('index'))

        try:
            db.execute(
                "INSERT INTO bookmarks (title, url, category, description) VALUES (?, ?, ?, ?)",
                (title, url, category, description)
            )
            db.commit()
        except sqlite3.Error as e:
            print(f"Database error when adding bookmark: {e}")
            # In a real app, log this and show a user-friendly error
        return redirect(url_for('index'))

    return render_template('index.html', bookmarks=bookmarks, categories=categories, selected_category=selected_category)

@app.route('/edit/<int:bookmark_id>', methods=['GET', 'POST'])
def edit_bookmark(bookmark_id):
    """
    Handles editing an existing bookmark.
    GET: Displays the edit form pre-filled with bookmark data.
    POST: Updates the bookmark in the database.
    """
    db = get_db()
    cursor = db.cursor()

    if request.method == 'POST':
        title = request.form['title'].strip()
        url = request.form['url'].strip()
        category = request.form['category'].strip()
        description = request.form.get('description', '').strip()

        if not title or not url or not category:
            print("Error: Title, URL, and Category are required for update.")
            return redirect(url_for('edit_bookmark', bookmark_id=bookmark_id))

        try:
            db.execute(
                "UPDATE bookmarks SET title = ?, url = ?, category = ?, description = ? WHERE id = ?",
                (title, url, category, description, bookmark_id)
            )
            db.commit()
        except sqlite3.Error as e:
            print(f"Database error when updating bookmark: {e}")
        return redirect(url_for('index'))
    else:
        # GET request: fetch bookmark data
        cursor.execute("SELECT * FROM bookmarks WHERE id = ?", (bookmark_id,))
        bookmark = cursor.fetchone()
        if bookmark is None:
            # Bookmark not found, redirect to home or show 404
            return redirect(url_for('index'))
        return render_template('edit_bookmark.html', bookmark=bookmark)

@app.route('/delete/<int:bookmark_id>', methods=['POST'])
def delete_bookmark(bookmark_id):
    """
    Deletes a bookmark from the database.
    """
    db = get_db()
    try:
        db.execute("DELETE FROM bookmarks WHERE id = ?", (bookmark_id,))
        db.commit()
    except sqlite3.Error as e:
        print(f"Database error when deleting bookmark: {e}")
    return redirect(url_for('index'))

# --- Main Execution Block ---
if __name__ == '__main__':
    # You can call init_db() here for convenience during development,
    # but for production, it's better to run it once manually or via a script.
    # init_db() # Uncomment to auto-initialize on run (first time only)
    app.run(debug=True, host='0.0.0.0', port=80) # debug=True enables auto-reloading and helpful error messages

