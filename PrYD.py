import tkinter as tk
from tkinter import messagebox, simpledialog
import pyodbc

class DatabaseApp:
    def __init__(self, master):
        self.master = master
        master.title("SQL Server Management")

        self.conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=Max-laptop;DATABASE=Shoe_shop;UID=User;PWD=1234')
        
        self.create_db_button = tk.Button(master, text="Create Database", command=self.create_database)
        self.create_db_button.pack()
        
        self.delete_db_button = tk.Button(master, text="Delete Database", command=self.delete_database)
        self.delete_db_button.pack()

        self.show_tables_button = tk.Button(master, text="Show tables", command=self.show_tables)
        self.show_tables_button.pack()

        self.clear_table_button = tk.Button(master, text="Clear Table", command=self.clear_table)
        self.clear_table_button.pack()

        self.clear_all_tables_button = tk.Button(master, text="Clear All Tables", command=self.clear_all_tables)
        self.clear_all_tables_button.pack()

        self.add_order_button = tk.Button(master, text="Add Order", command=self.add_order)
        self.add_order_button.pack()

        self.product_name_label = tk.Label(master, text="Enter Product Name:")
        self.product_name_label.pack()

        self.product_name_entry = tk.Entry(master)
        self.product_name_entry.pack()

        self.search_product_button = tk.Button(master, text="Search Product", command=self.search_products)
        self.search_product_button.pack()

        self.results_text = tk.Text(master, height=1, width=29)  # Текстовое поле для ссылки
        self.results_text.pack()

        self.product_name_label = tk.Label(master, text="Enter Product Name to Delete:")
        self.product_name_label.pack()

        self.product_name_exitry = tk.Entry(master)
        self.product_name_exitry.pack()

        self.delete_product_button = tk.Button(master, text="Delete Product", command=self.delete_products)
        self.delete_product_button.pack()

        self.product_id_label = tk.Label(master, text="Enter Product ID to Delete:")
        self.product_id_label.pack()

        self.product_id_entry = tk.Entry(master)
        self.product_id_entry.pack()

        self.delete_product_button = tk.Button(master, text="Delete Product", command=self.delete_product)
        self.delete_product_button.pack()

        self.update_product_button = tk.Button(master, text="Update Product", command=self.update_product)
        self.update_product_button.pack(pady=5)


    def create_database(self): #должна создавать таблицу и инициироваться
           cursor = self.conn.cursor()
           cursor.execute("EXEC CreateDatabase")
           self.conn.commit()
           messagebox.showinfo("Info", "Database created")

    def delete_database(self):
        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC DeleteDatabase")
            self.conn.commit()
            messagebox.showinfo("Info", "Database deleted.")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to delete database: {e}")
        finally:
            cursor.close()

    def show_tables(self):
         try:
             cursor = self.conn.cursor()
             cursor.execute("EXEC ShowTables")
             tables = cursor.fetchall()
     
         # Создание строки для вывода
             output = ""
     
             for table in tables:
                 output += f"Table: {table[0]}\n"  
                 cursor.execute(f"SELECT * FROM {table[0]}")
                 rows = cursor.fetchall()
                 for row in rows:
                 # Конвертация каждой "row" в строчку и добавление в вывод
                     output += ", ".join(str(item) for item in row) + "\n"
                 output += "\n"  # Новая строка для разделения таблиц
     
             messagebox.showinfo("Tables", output)
         except pyodbc.Error as e:
             messagebox.showerror("Error", f"Failed to retrieve tables: {e}")

    def clear_table(self):
        table_name = "Orders" #Очищается Orders
        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC ClearTable @TableName = ?", table_name)
            self.conn.commit()
            messagebox.showinfo("Info", f"Table {table_name} cleared")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to clear table: {e}")
        finally:
            cursor.close()

    def clear_all_tables(self):
        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC ClearAllTables")
            self.conn.commit()
            messagebox.showinfo("Info", "All tables cleared")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to clear all tables: {e}")
        finally:
            cursor.close()

    def add_order(self): 
        quantity = 2  # ВВОД

        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC AddOrder @Quantity = ?", quantity)
            self.conn.commit()
            messagebox.showinfo("Info", "Order added successfully")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to add order: {e}")
        finally:
            cursor.close()

    def search_products(self):
        product_name = self.product_name_entry.get()  # Получение текста из поля ввода

        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC SearchProductsByName @ProductName = ?", product_name)
            results = cursor.fetchall()  # Получение всех результатов

            # Очистка предыдущих результатов (если необходимо)
            self.results_text.delete(1.0, tk.END)

            # Обработка результатов (выводим их в текстовое поле)
            for row in results:
                self.results_text.insert(tk.END, row[0] + "\n")  # row[0] содержит значение Link

        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to search products: {e}")
        finally:
            cursor.close()

    def delete_products(self):
        product_name = self.product_name_exitry.get()  # Получение текста из поля ввода

        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC DeleteProductsByName @ProductName = ?", product_name)
            self.conn.commit()  # Подтверждение изменений в базе данных
            messagebox.showinfo("Success", "Products deleted successfully.")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to delete products: {e}")
        finally:
            cursor.close()

    def delete_product(self): #каскадное удаление на все product id во всех таблицах и каск. удаление на FK (или удалить логически)
        product_id = self.product_id_entry.get()  # Получение текста из поля ввода

        try:
            cursor = self.conn.cursor()
            cursor.execute("EXEC DeleteProductById @ProductId = ?", product_id)
            self.conn.commit()  # Подтверждение изменений в базе данных
            messagebox.showinfo("Success", "Product deleted successfully.")
        except pyodbc.Error as e:
            messagebox.showerror("Error", f"Failed to delete product: {e}")
        finally:
            cursor.close()

    def update_product(self):
            product_id = simpledialog.askinteger("Input", "Enter Product ID to update:")
            if product_id is not None:
                name = simpledialog.askstring("Input", "Enter new Name:")
                link = simpledialog.askstring("Input", "Enter new Link:")
                type_ = simpledialog.askinteger("Input", "Enter new Type:")

                if name and link and type_ is not None:
                    try:
                        cursor = self.conn.cursor()
                        cursor.execute("EXEC UpdateProduct ?, ?, ?, ?", product_id, name, link, type_)
                        self.conn.commit()
                        messagebox.showinfo("Success", "Product updated successfully!")
                    except Exception as e:
                        messagebox.showerror("Error", str(e))
                    finally:
                        cursor.close()


if __name__ == "__main__":
    root = tk.Tk()
    app = DatabaseApp(root)
    root.mainloop()