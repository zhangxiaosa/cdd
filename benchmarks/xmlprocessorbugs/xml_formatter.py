import xml.dom.minidom
import os
import sys

def format_xml(xml_string):
    parsed_xml = xml.dom.minidom.parseString(xml_string)
    return parsed_xml.toprettyxml()

def remove_blank_lines(xml_string):
    lines = [line for line in xml_string.splitlines() if line.strip() != ""]
    return "\n".join(lines)

def format_xml_files_in_folder(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            if filename.endswith(".xml"):
                file_path = os.path.join(root, filename)
                with open(file_path, "r", encoding="utf-8") as f:
                    xml_data = f.read()
                formatted_xml = format_xml(xml_data)
                # 这里应该使用formatted_xml而不是xml_data来移除空行
                formatted_xml_no_blanks = remove_blank_lines(formatted_xml)
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(formatted_xml_no_blanks)
                print(f"Formatted: {file_path}")

if __name__ == "__main__":
    folder_path = sys.argv[1]
    format_xml_files_in_folder(folder_path)

