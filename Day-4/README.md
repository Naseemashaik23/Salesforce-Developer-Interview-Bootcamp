# Salesforce Bootcamp – Day 4
## Lightning Web Components (LWC)

### 1. What is LWC?

Lightning Web Components (LWC) is Salesforce's modern web development framework used to build fast, lightweight, and reusable user interface components. It is based on standard web technologies such as HTML, JavaScript, and CSS, making it easier for developers to create responsive applications. LWC follows modern web standards and provides better performance compared to the older Aura Components framework. It is widely used in Salesforce to build custom applications, dashboards, forms, and interactive business solutions.

---

### 2. What did you build?

In this assignment, I developed a Lightning Web Component named **placementHome** for a Placement Management System.

The component includes the following features:

- Displays the student's name, roll number, and department.
- Uses data binding to dynamically display information stored in JavaScript variables.
- Includes a **"Show Welcome Message"** button that displays a welcome message when clicked.
- Includes an **"Apply Now"** button that changes the application status from **"Not Applied"** to **"Applied"**.
- Displays a simple placement dashboard containing placement-related information such as today's date, number of companies, available job openings, and submitted applications.
- The component was successfully deployed to Salesforce and added to a Lightning App Page using Lightning App Builder.

This assignment helped me understand how Lightning Web Components work and how user interactions are handled in Salesforce.

---

### 3. Which file contains HTML?

The **placementHome.html** file contains the HTML template of the Lightning Web Component.

Its responsibilities include:
- Designing the user interface.
- Displaying student information.
- Showing placement statistics.
- Creating buttons for user interaction.
- Displaying messages and application status using data binding.

This file defines how the component appears to the user.

---

### 4. Which file contains JavaScript?

The **placementHome.js** file contains the business logic of the component.

It is responsible for:
- Declaring variables such as student name, roll number, department, status, and placement statistics.
- Implementing data binding between JavaScript variables and the HTML page.
- Handling button click events.
- Updating the welcome message.
- Changing the application status dynamically when the user clicks the "Apply Now" button.

JavaScript makes the component interactive and controls its behavior.

---

### 5. What did you learn today?

During Day 4 of the Salesforce Bootcamp, I learned:

- The basics of Lightning Web Components (LWC).
- The structure and purpose of the HTML, JavaScript, and XML files in an LWC.
- How to create and deploy a Lightning Web Component.
- How data binding automatically updates the user interface.
- How to handle button click events using JavaScript.
- How to create interactive Salesforce applications.
- How to use Lightning App Builder to place an LWC on a Lightning App Page.
- The importance of reusable components in Salesforce application development.

This hands-on assignment improved my understanding of modern Salesforce front-end development and provided practical experience in building interactive Lightning Web Components.
