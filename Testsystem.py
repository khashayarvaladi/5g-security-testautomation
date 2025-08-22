import os
import subprocess
import threading
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from tkinter import messagebox, Toplevel, Listbox, SINGLE
from PIL import Image, ImageTk

# Define the directory paths where test files and logos are located
base_directory = "/home/exceeding/Mantra_5G"
results_directory = os.path.join(base_directory, "results")
generische_testkatalog = os.path.join(base_directory, "generische Testkatalog")
spezifische_testkatalog = os.path.join(base_directory, "spezifische Testkatalog")

logo_path = "/home/exceeding/Mantra_5G/exceeding.png"
tuevit_logo_path = "/home/exceeding/Mantra_5G/tuvit.jpg"

# Create the main application window with ttkbootstrap theme
root = ttk.Window(themename="darkly")
root.title("MANTRA5G Test Automation")
root.geometry("1920x1080")  # Increased window size to fit the output area

# Store test results for the table
test_results = []
selected_folder = ttk.StringVar(value="")  # Variable to store the selected folder

# Load the logos
def load_logo():
    try:
        logo_image = Image.open(logo_path)
        logo_image = logo_image.resize((200, 100), Image.Resampling.LANCZOS)
        return ImageTk.PhotoImage(logo_image)
    except Exception as e:
        print(f"Error loading main logo: {e}")
        return None

def load_tuevit_logo():
    try:
        tuevit_image = Image.open(tuevit_logo_path)
        tuevit_image = tuevit_image.resize((200, 100), Image.Resampling.LANCZOS)
        return ImageTk.PhotoImage(tuevit_image)
    except Exception as e:
        print(f"Error loading TueVIT logo: {e}")
        return None

# Function to load test cases from the selected directory
def load_test_cases_from_folder():
    folder_path = selected_folder.get()
    if not folder_path:
        messagebox.showerror("Error", "No folder selected!")
        return

    # Clear the existing checkboxes
    for widget in checkboxes_frame.winfo_children():
        widget.destroy()

    # Load test cases from the selected folder
    for folder in os.listdir(folder_path):
        folder_full_path = os.path.join(folder_path, folder)
        if os.path.isdir(folder_full_path):
            for file in os.listdir(folder_full_path):
                if file.endswith(".robot"):
                    test_case_path = os.path.join(folder_full_path, file)

                    # Create a checkbox for each test case
                    var = ttk.StringVar(value=test_case_path)
                    chk = ttk.BooleanVar()
                    chkbox = ttk.Checkbutton(
                        checkboxes_frame,
                        text=f"{folder}/{file}",
                        variable=chk,
                        bootstyle="round-toggle",
                    )
                    chkbox.pack(anchor="w", padx=5, pady=2)
                    checkboxes.append((var, chk))
    messagebox.showinfo("Info", f"Test cases loaded from {folder_path}")

# Function to run the selected test cases in a separate thread
def run_tests_in_thread():
    selected_tests = [var.get() for var, chk in checkboxes if chk.get()]
    if not selected_tests:
        messagebox.showerror("Error", "No test cases selected!")
        return

    progress_bar["value"] = 0
    progress_bar["maximum"] = len(selected_tests)  # Maximum value for the progress bar
    for row in results_table.get_children():
        results_table.delete(row)  # Clear previous results

    thread = threading.Thread(target=run_tests, args=(selected_tests,))
    thread.start()

# Function to run the selected test cases
def run_tests(selected_tests):
    status_label.config(text="Running selected tests...")
    root.update()

    for index, test_suite_path in enumerate(selected_tests, start=1):
        folder_name = os.path.basename(test_suite_path)
        test_output_dir = os.path.join(results_directory, folder_name)

        if not os.path.exists(test_output_dir):
            os.makedirs(test_output_dir)

        command = f"robot --outputdir '{test_output_dir}' '{test_suite_path}'"
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        test_passed = False
        for line in process.stdout:
            if "PASS" in line:
                test_passed = True
            elif "FAIL" in line:
                test_passed = False

        process.wait()

        status = "PASS" if test_passed else "FAIL"
        color = "green" if test_passed else "red"

        results_table.insert("", "end", values=(folder_name, status), tags=(color,))
        results_table.tag_configure("green", background="#28a745", foreground="white")
        results_table.tag_configure("red", background="#dc3545", foreground="white")

        progress_bar.step(1)
        progress_label.config(text=f"Completed {index} of {len(selected_tests)} tests")
        root.update_idletasks()

    status_label.config(text="Tests completed!")
    messagebox.showinfo("Success", "All tests completed!")

# Function to open log or report files from the results folder
def open_file_dialog(file_type):
    dialog = Toplevel(root)
    dialog.title(f"Select {file_type}")
    dialog.geometry("400x300")

    listbox = Listbox(dialog, selectmode=SINGLE, font=("Arial", 10))
    listbox.pack(fill="both", expand=True, padx=20, pady=20)

    for folder in os.listdir(results_directory):
        folder_full_path = os.path.join(results_directory, folder)
        if os.path.isdir(folder_full_path):
            listbox.insert("end", folder)

    def open_selected_file():
        selected_index = listbox.curselection()
        if selected_index:
            folder_name = listbox.get(selected_index)
            file_path = os.path.join(results_directory, folder_name, f"{file_type}.html")

            if os.path.exists(file_path):
                subprocess.run(["xdg-open", file_path])
            else:
                messagebox.showerror("Error", f"{file_type.capitalize()} file not found in {folder_name}!")
            dialog.destroy()

    open_button = ttk.Button(dialog, text=f"Open {file_type.capitalize()}", command=open_selected_file)
    open_button.pack(pady=10)

# Layout adjustments
top_frame = ttk.Frame(root)
top_frame.pack(fill="x", pady=10)

logo_image = load_logo()
if logo_image:
    left_logo_label = ttk.Label(top_frame, image=logo_image)
    left_logo_label.image = logo_image
    left_logo_label.pack(side="left", padx=10)

tuevit_logo_image = load_tuevit_logo()
if tuevit_logo_image:
    right_logo_label = ttk.Label(top_frame, image=tuevit_logo_image)
    right_logo_label.image = tuevit_logo_image
    right_logo_label.pack(side="right", padx=10)

header_label = ttk.Label(root, text="MANTRA5G Test Automation", font=("Helvetica", 16, "bold"), bootstyle="info")
header_label.pack(pady=10)

folder_selection_frame = ttk.Frame(root)
folder_selection_frame.pack(pady=10)
ttk.Label(folder_selection_frame, text="Select Test Catalog:", font=("Arial", 12)).pack(side="left", padx=10)

folder_dropdown = ttk.Combobox(
    folder_selection_frame,
    textvariable=selected_folder,
    values=[generische_testkatalog, spezifische_testkatalog],
    width=50,
)
folder_dropdown.pack(side="left", padx=10)

load_button = ttk.Button(
    folder_selection_frame,
    text="Load Test Cases",
    command=load_test_cases_from_folder,
    bootstyle="primary-outline",
)
load_button.pack(side="left", padx=10)

checkboxes_frame = ttk.Frame(root)
checkboxes_frame.pack(pady=10)

run_tests_button = ttk.Button(root, text="Run Tests", command=run_tests_in_thread, bootstyle="success-outline")
run_tests_button.pack(pady=10)

view_log_button = ttk.Button(root, text="View Log", command=lambda: open_file_dialog("log"), bootstyle="primary-outline")
view_log_button.pack(pady=5)

view_report_button = ttk.Button(root, text="View Report", command=lambda: open_file_dialog("report"), bootstyle="primary-outline")
view_report_button.pack(pady=5)

status_label = ttk.Label(root, text="Ready", font=("Arial", 10), bootstyle="secondary")
status_label.pack(pady=10)

progress_label = ttk.Label(root, text="Progress", font=("Arial", 10), bootstyle="secondary")
progress_label.pack(pady=10)

progress_bar = ttk.Progressbar(root, mode="determinate", bootstyle="success-striped")
progress_bar.pack(fill="x", padx=10, pady=10)

results_table = ttk.Treeview(root, columns=("Test Case", "Status"), show="headings", height=10)
results_table.heading("Test Case", text="Test Case")
results_table.heading("Status", text="Status")
results_table.column("Test Case", width=400, anchor="center")
results_table.column("Status", width=100, anchor="center")
results_table.tag_configure("green", background="#28a745", foreground="white")
results_table.tag_configure("red", background="#dc3545", foreground="white")
results_table.pack(pady=20)

checkboxes = []

root.mainloop()
