 /*
 Array of objects
 Create a class employee
 Collect
    Employee name
    Employee age
Display this information for every employee
 */


#include<iostream>
using namespace std;

class employee
{
    static int emp_id;   // Static member
	char  emp_name[20];
	int emp_age;

	public:
    employee()   // contructor 
        {
        ++emp_id;
        }
    void get_emp_details();
    void show_emp_details();
};

void employee :: get_emp_details()
{
	cout<<"\nEnter employee name: ";
	cin>>emp_name;
	cout<<"\nEnter employee Age: ";
	cin>>emp_age;
}

void employee :: show_emp_details()
{
	cout<<"\n\n**** Details of  Employee ****";
	cout<<"\nEmployee ID        :  "<<emp_id;
	cout<<"\nEmployee Name      :  "<<emp_name;
	cout<<"\nEmployee Age       :  "<<emp_age;
	cout<<"\n-------------------------------\n\n";
}

int employee::emp_id;

int main()
{
    employee emp1;
    emp1.get_emp_details();
    emp1.show_emp_details();

    employee emp2;
    emp2.get_emp_details();
    emp2.show_emp_details();
    
    int count = 100;
    employee engineers[count];
    for (int i = 0; i < count; i++)
    {
        engineers[i].get_emp_details();
        engineers[i].show_emp_details();
    }    

    return 0;
}
