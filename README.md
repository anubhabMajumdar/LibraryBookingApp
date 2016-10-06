# Program1\_ECE517

--
<center>
##Click [here](https://www.youtube.com/playlist?list=PLaclCVvd8mtfOWUS1UDCcrjGZFiAXYVPQ) to watch demo video
</center>

Github Link:

[https://github.ncsu.edu/lzhang45/ECE517_project1](https://github.ncsu.edu/lzhang45/ECE517_project1)

--

Root Account:

Email: amajumd@ncsu.edu

Password: anubhab123#


##Test procedure:

Just go to [https://librarybooking.herokuapp.com](https://librarybooking.herokuapp.com), our website is very user-friendly, basically you can try to use every kind of feature shown in Question Page.

If you log in as a normal user, you can 

1. Log in with email and password; (One email cannot be used by more than one user.)
2. Edit your profile details;
3. Search rooms using room number, size, building or status;
4. View details of a room;
5. Book a room if status is "avaliable"; (One day is divided to 48 slots, each of them lasts 30 minutes. One booking should contain no more than 4 slots. The start time should not be in the past and should be within 7 days.)
6. Release booked room; (If you cancel a booking before the startime of it, you just cancel this bookings. But if you cancel a booking during the process and we will update the endtime, like if you book the room from 10:00 am to 11:30 am, and you cancel it in 10:57am, the endtime will be updated to 11:00 am. Other user can book this room from 11:00 am to 11:30 am.)
7. View your own booking history.

If you log in as a normal admin, you can also do some more things

1. Create new admins; (First you need to sign up the user and then use an admin to search the email and grant the upgrade process.)
2. View the list of all admins and their profile details (except password);
3. Delete admins (except herself/himself and the preconfigured Admin);
4. Manage rooms. Including add room, view lists of all rooms, view details of a room, edit the details of a room, view booking story of a room and delete a room from system. (Room number is unique.)
5. Manage library members. Including view list of library members and profile details, view the reservation history of a library member, and delete a library member.
6. the admin can cancel users' bookings.

If you log in as root, you can also do some more things:

1. You cannot be deleted by anyone.


##Bonus Part:

1. If a library member has successfully booked a room, the system can send a notification message to other library members in his/her team with the details of the reservation. We are using heroku and mailgun free of charge to achieve this. Mailgun needs you to verify your domain from companies like GoDaddy for sending mail to anyone. The verification takes more than 48 hours and associated charge. So we are testing a sandbox domain which comes free. This only allows sending mail to receipients who agree to receive mail from this domain. Currently only 2 email-ids are registered - amajumd@ncsu.edu and htan5@ncsu.edu. If you enter any other email, it will crash. So please send a mail to amajumd@ncsu.edu and I will register your mail id. Then you can send mail to yourself. Kindly bear with us on this. 
2. A library member can reserve only one room at a particular date and time. Only after his/her reservation is released, he/she can proceed to reserve another room. But an admin can allow a library member to reserve multiple rooms at one time.
3. If you cancel a booking before the startime of it, you just cancel this bookings. But if you cancel a booking during the process and we will update the endtime, like if you book the room from 10:00 am to 11:30 am, and you cancel it in 10:57am, the endtime will be updated to 11:00 am. Other user can book this room from 11:00 am to 11:30 am.
4. If you delete an user or a room, related future booking record will be automatically destroyed. But the hisotry will be reserved for information completeness.


##Notes

css code is borrowed from free sources

We use sqlite3 as local database software and pg as Heroku database software.

we have used standard session controller design for login logout
