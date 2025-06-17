import csv
from urllib.parse import urlparse

input_file = "data/csic_database.csv"
good_file = "data/goodqueries.txt"
bad_file = "data/badqueries.txt"

with open(input_file, newline='', encoding="utf-8") as csvfile, \
     open(good_file, "w", encoding="utf-8") as good_out, \
     open(bad_file, "w", encoding="utf-8") as bad_out:

    reader = csv.reader(csvfile)

    for row in reader:
        if not row or len(row) < 17:
            continue  # skip malformed rows

        label = row[0].strip()
        method = row[1].strip()
        url = row[16].strip()

        if url.endswith("HTTP/1.1"):
            url = url.replace(" HTTP/1.1", "")

        parsed = urlparse(url)
        path = parsed.path

        if path.startswith("/tienda1"):
            path = path[len("/tienda1"):]

        query = f"?{parsed.query}" if parsed.query else ""
        clean_url = f"{method} {path}{query}"

        if label == "Normal":
            good_out.write(clean_url + "\n")
        elif label == "Anomalous":
            bad_out.write(clean_url + "\n")
