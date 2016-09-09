from PyOrgMode import PyOrgMode

base = PyOrgMode.OrgDataStructure()
base.load_from_file("scratch.org")


# print base.root.content


# print base.root.content[-1].content


new_todo = PyOrgMode.OrgNode.Element()
new_todo.heading = "test1"
new_todo.todo = "TODO"


base.root.append_clean(new_todo)
# base.save_to_file("out.org")




with open('scratch.org', 'a') as f:
    f.write("** TODO a new test ")
