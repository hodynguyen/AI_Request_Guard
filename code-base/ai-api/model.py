def is_malicious(path: str, args: dict) -> bool:
    # Chặn nếu URL có chứa SQL/XSS keyword cơ bản
    block_keywords = ["union", "select", "drop", "<script>", "--"]
    lower_path = path.lower()
    full_text = lower_path + " " + str(args).lower()
    return any(kw in full_text for kw in block_keywords)
