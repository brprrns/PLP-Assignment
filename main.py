from gradebook import Student, generate_report


students = [
    Student("Priya"),
    Student("Rahul"),
    Student("Ananya")
]

report = generate_report(students)

print(report)