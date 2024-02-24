import xml.dom.minidom
import os
import sys

def format_xml(xml_string):
    parsed_xml = xml.dom.minidom.parseString(xml_string)
    return parsed_xml.toprettyxml()

def format_xml_files_in_folder(folder_path):
    for filename in os.listdir(folder_path):
        if filename.endswith(".xml"):
            file_path = os.path.join(folder_path, filename)
            with open(file_path, "r", encoding="utf-8") as f:
                xml_data = f.read()
            formatted_xml = format_xml(xml_data)
            formatted_xml = remove_blank_lines(xml_data)
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(formatted_xml)
            print(f"Formatted: {file_path}")

def remove_blank_lines(xml_string):
    lines = [line for line in xml_string.splitlines() if line.strip() != ""]
    return "\n".join(lines)

if __name__ == "__main__":
    folder_path = sys.argv[1]
    format_xml_files_in_folder(folder_path)

