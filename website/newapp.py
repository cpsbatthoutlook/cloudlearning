from flask import Flask, render_template, request, redirect, url_for, flash
import sqlite3

app = Flask(__name__)
app.secret_key = 'your_secret_key' # Change this to a strong, random key in production

DATABASE = 'bookmarks.db'

def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/')
def index():
    conn = get_db_connection()
    categories = conn.execute('SELECT DISTINCT category FROM bookmarks ORDER BY category').fetchall()
    
    selected_category = request.args.get('category')
    
    if selected_category and selected_category != 'All':
        bookmarks = conn.execute('SELECT * FROM bookmarks WHERE category = ? ORDER BY title', (selected_category,)).fetchall()
    else:
        bookmarks = conn.execute('SELECT * FROM bookmarks ORDER BY title').fetchall()
        
    conn.close()
    return render_template('new_index.html', bookmarks=bookmarks, categories=categories, selected_category=selected_category)

@app.route('/add', methods=('GET', 'POST'))
def add_bookmark():
    conn = get_db_connection()
    categories = conn.execute('SELECT DISTINCT category FROM bookmarks ORDER BY category').fetchall()
    conn.close()

    if request.method == 'POST':
        title = request.form['title']
        url = request.form['url']
        category = request.form['category']
        new_category = request.form['new_category']
        description = request.form['description']

        if not title or not url:
            flash('Title and URL are required!', 'error')
        else:
            conn = get_db_connection()
            try:
                if new_category:
                    category_to_use = new_category
                else:
                    category_to_use = category if category != 'select_category' else 'Uncategorized' # Default if no new category and no selection
                
                conn.execute('INSERT INTO bookmarks (title, url, category, description) VALUES (?, ?, ?, ?)',
                             (title, url, category_to_use, description))
                conn.commit()
                flash('Bookmark added successfully!', 'success')
                return redirect(url_for('index'))
            except sqlite3.IntegrityError:
                flash('An error occurred while adding the bookmark.', 'error')
            finally:
                conn.close()

    return render_template('new_add_bookmark.html', categories=categories)

@app.route('/edit/<int:id>', methods=('GET', 'POST'))
def edit_bookmark(id):
    conn = get_db_connection()
    bookmark = conn.execute('SELECT * FROM bookmarks WHERE id = ?', (id,)).fetchone()
    categories = conn.execute('SELECT DISTINCT category FROM bookmarks ORDER BY category').fetchall()
    conn.close()

    if bookmark is None:
        flash('Bookmark not found!', 'error')
        return redirect(url_for('index'))

    if request.method == 'POST':
        title = request.form['title']
        url = request.form['url']
        category = request.form['category']
        new_category = request.form['new_category']
        description = request.form['description']

        if not title or not url:
            flash('Title and URL are required!', 'error')
        else:
            conn = get_db_connection()
            try:
                if new_category:
                    category_to_use = new_category
                else:
                    category_to_use = category if category != 'select_category' else 'Uncategorized'
                
                conn.execute('UPDATE bookmarks SET title = ?, url = ?, category = ?, description = ? WHERE id = ?',
                             (title, url, category_to_use, description, id))
                conn.commit()
                flash('Bookmark updated successfully!', 'success')
                return redirect(url_for('index'))
            except sqlite3.Error as e:
                flash(f'An error occurred while updating the bookmark: {e}', 'error')
            finally:
                conn.close()

    return render_template('new_edit_bookmark.html', bookmark=bookmark, categories=categories)


@app.route('/delete/<int:id>', methods=('POST',))
def delete_bookmark(id):
    conn = get_db_connection()
    try:
        conn.execute('DELETE FROM bookmarks WHERE id = ?', (id,))
        conn.commit()
        flash('Bookmark deleted successfully!', 'success')
    except sqlite3.Error as e:
        flash(f'An error occurred while deleting the bookmark: {e}', 'error')
    finally:
        conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
