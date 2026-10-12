locals {
  departments = {
    IT = {
      group_name = "GG-IT-Employees"

      employees = [
        "it-user-01",
        "it-user-02"
      ]
    }

    HR = {
      group_name = "GG-HR-Employees"

      employees = [
        "hr-user-01",
        "hr-user-02"
      ]
    }

    Finance = {
      group_name = "GG-Finance-Employees"

      employees = [
        "finance-user-01",
        "finance-user-02"
      ]
    }
  }

  employees = merge([
    for department_name, department in local.departments : {
      for username in department.employees : username => {
        department = department_name
        group_name = department.group_name
      }
    }
  ]...)
}