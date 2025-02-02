import mysql.connector

def connect_db():
    """Connect to MySQL Database"""
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="alx_book_store"
    )

def create_tables():
    """Create tables if not exists"""
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Authors (
            author_id INT AUTO_INCREMENT PRIMARY KEY,
            author_name VARCHAR(215)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Books (
            book_id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(130),
            author_id INT,
            price DOUBLE,
            publication_date DATE,
            FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Customers (
            customer_id INT AUTO_INCREMENT PRIMARY KEY,
            customer_name VARCHAR(215),
            email VARCHAR(215),
            address TEXT
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Orders (
            order_id INT AUTO_INCREMENT PRIMARY KEY,
            customer_id INT,
            order_date DATE,
            FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Order_Details (
            orderdetailid INT AUTO_INCREMENT PRIMARY KEY,
            order_id INT,
            book_id INT,
            quantity DOUBLE,
            FOREIGN KEY (order_id) REFERENCES Orders(order_id),
            FOREIGN KEY (book_id) REFERENCES Books(book_id)
        )
    """)
    db.commit()
    cursor.close()
    db.close()

def add_book(title, author_id, price, publication_date):
    """Add a new book to the database"""
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("INSERT INTO Books (title, author_id, price, publication_date) VALUES (%s, %s, %s, %s)", (title, author_id, price, publication_date))
    db.commit()
    print("Book added successfully!")
    cursor.close()
    db.close()

def search_book(title):
    """Search for a book by title"""
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM Books WHERE title LIKE %s", ("%" + title + "%",))
    results = cursor.fetchall()
    if results:
        for book in results:
            print(f"ID: {book[0]}, Title: {book[1]}, Author ID: {book[2]}, Price: {book[3]}, Publication Date: {book[4]}")
    else:
        print("No book found with that title.")
    cursor.close()
    db.close()

def list_books():
    """List all books in the library"""
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM Books")
    books = cursor.fetchall()
    if books:
        for book in books:
            print(f"ID: {book[0]}, Title: {book[1]}, Author ID: {book[2]}, Price: {book[3]}, Publication Date: {book[4]}")
    else:
        print("No books in the library.")
    cursor.close()
    db.close()

def delete_book(book_id):
    """Delete a book by its ID"""
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("DELETE FROM Books WHERE book_id = %s", (book_id,))
    db.commit()
    if cursor.rowcount:
        print("Book deleted successfully!")
    else:
        print("No book found with that ID.")
    cursor.close()
    db.close()

