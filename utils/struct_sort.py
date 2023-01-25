import re
import sys

"""
Util that takes a solidity file containing struct definitions as a command-line
argument and outputs a new file with the same struct definitions, but with their
members sorted alphabetically by name, and 'Json' appended to the end of the
struct name.
It also generates a library file that contains functions to convert between them.
"""
# regex to non-greedily capture each struct definition as well as its name
struct_re = r"(struct ([a-zA-z0-9_]+) {[\s\S]*?})"
# regex to capture each member of a struct; the member name is group #4 (index #3)
member_re = r"\s+(([a-zA-Z0-9_]+)(\[\])? (payable )?([a-zA-z0-9_]+);)"


def parse_struct_definitions(contents: str) -> list[str]:
    """Parse the struct definitions from a solidity file.

    Args:
        contents (str): The contents of a solidity file.

    Returns:
        list: A list of tuples containing the struct definition and the struct name.
    """
    structs = re.findall(struct_re, contents)
    return structs


def parse_struct_members_and_sort(
    struct_definition: str,
) -> list[tuple[str, str, str, str, str]]:
    """Parse the members of a struct and sort them by name.

    Args:
        struct_def (list[str]): A list of tuples containing the struct definition and the struct name.

    Returns:
        list[str]: A list of the members of the struct, sorted by name.
    """
    members = re.findall(member_re, struct_definition)
    members.sort(key=lambda x: x[4])
    return members


def generate_new_struct_definition(
    name: str,
    sorted_struct_def: list[tuple[str, str, str, str, str]],
    name_set: set[str],
) -> str:
    new_defs: list[str] = []
    for def_tuple in sorted_struct_def:
        print(def_tuple)
        member_type = def_tuple[1]
        member_type = (
            member_type if member_type not in name_set else f"{member_type}Json"
        )
        optional_array_brackets = def_tuple[2]
        new_defs.append(
            " ".join([member_type + optional_array_brackets] + list(def_tuple[3:]))
            + ";"
        )

    return f"struct {name}Json {{ {chr(10) + chr(10).join(new_defs)} }}"


def generate_library_import(name: str) -> str:
    return f"{name}Json"


def generate_library_using(name: str) -> str:
    return f"""
    using JsonStructLib for {name}Json;
    using JsonStructLib for {name}Json[];
    """


def generate_library_function(
    name: str,
    sorted_struct_def: list[tuple[str, str, str, str, str]],
    name_set: set[str],
) -> str:
    single = f"""
    function toStandard({name}Json memory a) internal pure returns ({name} memory) {{
         return {name}({{ {','.join(f'{m[4]}:a.{m[4] + (".toStandard()" if m[1] in name_set else "")}' for m in sorted_struct_def)} }}); 
    }}
    """
    multi = f"""
    function toStandard({name}Json[] memory a) internal pure returns ({name}[] memory) {{
        {name}[] memory b = new {name}[](a.length);
        for (uint i = 0; i < a.length; i++) {{
            b[i] = {name}({{ {','.join(f'{m[4]}:a[i].{m[4] + (".toStandard()" if m[1] in name_set else "")}' for m in sorted_struct_def)} }});
        }}
        return b;
    }}
    """
    return single + "\n\n" + multi


# grab the file name from command line arg
fname = sys.argv[1]

with open(fname) as f:
    contents = f.read()

# find all the struct definitions
structs = re.findall(struct_re, contents)


# keep track of new struct definitions
new_defs = []
# keep track of structs to import from new file
library_imports = []
og_imports = []
# "using" defs
library_using = []
# keep track of library functions
library_funcs = []

name_set = set(s[1] for s in structs)
print(name_set)
for struct in structs:
    definition = struct[0]
    name = struct[1]
    name_set.add(name)
    sorted_members = parse_struct_members_and_sort(definition)
    new_defs.append(generate_new_struct_definition(name, sorted_members, name_set))
    library_imports.append(generate_library_import(name))
    og_imports.append(name)
    library_using.append(generate_library_using(name))
    library_funcs.append(generate_library_function(name, sorted_members, name_set))


# # iterate over each struct definition
# for struct in structs:
#     # grab the name and definition
#     name = struct[1]
#     definition = struct[0]
#     # print(definition, name)
#     # find all the members
#     members = re.findall(member_re, definition)
#     # sort the members by name
#     members.sort(key=lambda x: x[3])
#     # join the members back together
#     new_def = (
#         f"struct {name}Json {{ {chr(10) + chr(10).join([m[0] for m in members])} }}"
#     )
#     new_defs.append(new_def)
#     library_imports.append(f"{name}Json")
#     library_funcs.append(
#         f"""
#     function toStandard({name}Json memory a) internal pure returns ({name} memory) {{
#          return {name}({{ {','.join(f'{m[3]}:a.{m[3]}' for m in members)} }});
#     }}"""
#     )
#     print(library_funcs[-1])

with open("JsonStructs.sol", "w") as f:
    f.write("\n\n".join(new_defs))

with open("JsonStructLib.sol", "w") as f:
    f.write("import {")
    f.write(",\n".join(library_imports))
    f.write('} from "./JsonStructs.sol";\n\n')
    f.write("import {")
    f.write(",\n".join(og_imports))
    f.write('} from "path/to/Original.sol";\n\n')
    f.write("library JsonStructLib {")
    f.write("\n\n".join(library_using))
    f.write("\n\n".join(library_funcs))
    f.write("}")
