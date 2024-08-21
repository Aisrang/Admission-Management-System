// SPDX-License-Identifier: MIT
pragma solidity 0.8.26; // Defining the version of solidity

// Created a smart contract of the project.
contract AdmissionManagementSystem { 
    struct Student {
        string name;
        uint age;
        string course;
        bool isAdmitted;
    }

    // Defining variables and array to store data as well as mapping the address to access its contents.
    address public admin = 0x9D775f6d8a1Ae60864Ff4f9b7e4D1557635eC2A9;
    mapping(address => Student) private students;
    address[] private studentAddresses;

    // Initializing events to log these particular actions that occur in within the contract.
    event StudentAdded(address indexed studentAddress, string name, uint age, string course);
    event StudentUpdated(address indexed studentAddress, string name, uint age, string course);
    event AdmissionStatusChanged(address indexed studentAddress, bool isAdmitted);

    // To control access to some functions which can be performed by the owner only.
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    // A function to insert new student if the student is not registered already.
    function addStudent(address _studentAddress, string memory _name, uint _age, string memory _course) public onlyAdmin {
        require(!students[_studentAddress].isAdmitted, "Student already admitted.");
        students[_studentAddress] = Student(_name, _age, _course, true);
        studentAddresses.push(_studentAddress);
        emit StudentAdded(_studentAddress, _name, _age, _course);
    }

    // Update student information after admission when needed.
    function updateStudent(address _studentAddress, string memory _name, uint _age, string memory _course) public onlyAdmin {
        require(students[_studentAddress].isAdmitted, "Student not found.");
        students[_studentAddress].name = _name;
        students[_studentAddress].age = _age;
        students[_studentAddress].course = _course;
        emit StudentUpdated(_studentAddress, _name, _age, _course);
    }

    // Changes admission status of a particular student. The status is "true" by default when the student is added.
    function changeAdmissionStatus(address _studentAddress, bool _status) public onlyAdmin {
        require(students[_studentAddress].isAdmitted != _status, "Status is already set to the requested value.");
        students[_studentAddress].isAdmitted = _status;
        emit AdmissionStatusChanged(_studentAddress, _status);
    }

    // Get the information of a particular student by using his/her address.
    function getStudent(address _studentAddress) public view returns (string memory, uint, string memory, bool) {
        Student memory student = students[_studentAddress];
        return (student.name, student.age, student.course, student.isAdmitted);
    }

    // Display the addresses of every student admitted in the system.
    function listAllStudents() public view returns (address[] memory) {
        return studentAddresses;
    }
}
