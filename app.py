import streamlit as st
import mysql.connector
import pandas as pd

# --- MySQL Connection ---
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Pkk1234#",  # change if needed
        database="Research_Paper_Repository"
    )

# --- App Layout ---
st.set_page_config(page_title="Research Paper Repository", layout="wide")
st.title("📚 Research Paper Repository")

# --- Sidebar Options ---
st.sidebar.header("Navigation")
page = st.sidebar.radio("Go to:", ["🔍 Search Papers", "➕ Add New Paper", "❌ Delete Paper"])

# ---------------------------------------------------------
# 🔍 SEARCH SECTION
# ---------------------------------------------------------
if page == "🔍 Search Papers":
    st.subheader("Search Research Papers")

    search_type = st.radio("Search by:", ("Paper Title", "Author Name"))
    search_query = st.text_input("Enter search term:")

    if st.button("🔍 Search"):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        if search_type == "Paper Title":
            query = """
            SELECT rp.Paper_ID, rp.Title, rp.Abstract, rp.Year, rp.DOI,
                   j.Journal_Name, c.Conference_Name,
                   GROUP_CONCAT(DISTINCT a.Name SEPARATOR ', ') AS Authors,
                   GROUP_CONCAT(DISTINCT r.Name SEPARATOR ', ') AS Reviewers
            FROM Research_Paper rp
            LEFT JOIN Paper_Author pa ON rp.Paper_ID = pa.Paper_ID
            LEFT JOIN Author a ON pa.Author_ID = a.Author_ID
            LEFT JOIN Paper_Reviewer pr ON rp.Paper_ID = pr.Paper_ID
            LEFT JOIN Reviewer r ON pr.Reviewer_ID = r.Reviewer_ID
            LEFT JOIN Journal j ON rp.Journal_ID = j.Journal_ID
            LEFT JOIN Conference c ON rp.Conference_ID = c.Conference_ID
            WHERE rp.Title LIKE %s
            GROUP BY rp.Paper_ID;
            """
            cursor.execute(query, (f"%{search_query}%",))
        else:
            query = """
            SELECT rp.Paper_ID, rp.Title, rp.Abstract, rp.Year, rp.DOI,
                   j.Journal_Name, c.Conference_Name,
                   GROUP_CONCAT(DISTINCT a.Name SEPARATOR ', ') AS Authors,
                   GROUP_CONCAT(DISTINCT r.Name SEPARATOR ', ') AS Reviewers
            FROM Research_Paper rp
            LEFT JOIN Paper_Author pa ON rp.Paper_ID = pa.Paper_ID
            LEFT JOIN Author a ON pa.Author_ID = a.Author_ID
            LEFT JOIN Paper_Reviewer pr ON rp.Paper_ID = pr.Paper_ID
            LEFT JOIN Reviewer r ON pr.Reviewer_ID = r.Reviewer_ID
            LEFT JOIN Journal j ON rp.Journal_ID = j.Journal_ID
            LEFT JOIN Conference c ON rp.Conference_ID = c.Conference_ID
            WHERE a.Name LIKE %s
            GROUP BY rp.Paper_ID;
            """
            cursor.execute(query, (f"%{search_query}%",))

        results = cursor.fetchall()
        cursor.close()
        conn.close()

        if results:
            df = pd.DataFrame(results)
            st.success(f"✅ Found {len(df)} matching result(s)")
            st.dataframe(df)
        else:
            st.warning("⚠️ No results found. Try another search term!")

# ---------------------------------------------------------
# ➕ ADD NEW PAPER
# ---------------------------------------------------------
elif page == "➕ Add New Paper":
    st.subheader("Add a New Research Paper")

    # Input fields
    title = st.text_input("Title")
    abstract = st.text_area("Abstract")
    year = st.number_input("Year", min_value=1900, max_value=2100, step=1)
    doi = st.text_input("DOI")
    author_name = st.text_input("Author Name")
    author_email = st.text_input("Author Email")

    st.write("Select either a Conference OR a Journal:")
    conf_id = st.number_input("Conference ID (enter 0 if none)", min_value=0, step=1)
    journal_id = st.number_input("Journal ID (enter 0 if none)", min_value=0, step=1)

    if conf_id != 0 and journal_id != 0:
        st.error("⚠️ Please select either a Conference OR a Journal, not both.")
    elif conf_id == 0 and journal_id == 0:
        st.error("⚠️ Please select at least one (Conference or Journal).")
    elif st.button("✅ Add Paper"):

        if not author_name or not author_email:
            st.warning("⚠️ Please enter both Author Name and Email!")
        elif not doi:
            st.warning("⚠️ Please enter DOI!")
        else:
            conn = get_connection()
            cursor = conn.cursor()

            # Check if DOI already exists
            cursor.execute("SELECT Paper_ID FROM Research_Paper WHERE DOI = %s", (doi,))
            if cursor.fetchone():
                st.error(f"⚠️ Paper with DOI '{doi}' already exists!")
            else:
                # Generate next Paper_ID
                cursor.execute("SELECT IFNULL(MAX(Paper_ID), 0) + 1 FROM Research_Paper;")
                next_paper_id = cursor.fetchone()[0]

                # Insert into Research_Paper
                cursor.execute("""
                    INSERT INTO Research_Paper (Paper_ID, Title, Abstract, Year, DOI, Conference_ID, Journal_ID)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (next_paper_id, title, abstract, year, doi,
                      conf_id if conf_id != 0 else None,
                      journal_id if journal_id != 0 else None))

                # Check if author exists, else insert
                cursor.execute("SELECT Author_ID FROM Author WHERE Name = %s", (author_name,))
                author_row = cursor.fetchone()
                if author_row:
                    author_id = author_row[0]
                else:
                    cursor.execute("SELECT IFNULL(MAX(Author_ID), 0) + 1 FROM Author;")
                    author_id = cursor.fetchone()[0]
                    cursor.execute(
                        "INSERT INTO Author (Author_ID, Name, Email, Affiliation, Dept_ID) VALUES (%s, %s, %s, NULL, NULL)",
                        (author_id, author_name, author_email)
                    )

                # Insert into Paper_Author
                cursor.execute("INSERT INTO Paper_Author (Paper_ID, Author_ID) VALUES (%s, %s)", (next_paper_id, author_id))

                conn.commit()
                cursor.close()
                conn.close()
                st.success("✅ Research paper added successfully!")

# ---------------------------------------------------------
# ❌ DELETE PAPER
# ---------------------------------------------------------
elif page == "❌ Delete Paper":
    st.subheader("Delete a Research Paper")

    paper_id = st.number_input("Enter Paper ID to delete", min_value=1, step=1)
    if st.button("🗑️ Delete"):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Paper_Author WHERE Paper_ID = %s", (paper_id,))
        cursor.execute("DELETE FROM Paper_Reviewer WHERE Paper_ID = %s", (paper_id,))
        cursor.execute("DELETE FROM Research_Paper WHERE Paper_ID = %s", (paper_id,))
        conn.commit()
        cursor.close()
        conn.close()
        st.success(f"✅ Paper ID {paper_id} deleted successfully!")

# ---------------------------------------------------------
# Footer
# ---------------------------------------------------------
st.markdown("---")
# st.caption("Developed by Priyanka Kiran Khatavkar 🌸 | DBMS Mini Project")
