function [cx, cz] = CMcalculator(Theta1, Theta2, Theta3, PhysicalProperties)

th1 = Theta1;
th2 = Theta2;
th3 = Theta3;

m0 = PhysicalProperties(1);
m1 = PhysicalProperties(2);
m2 = PhysicalProperties(3);
m3 = PhysicalProperties(4);
l1 = PhysicalProperties(5);
l2 = PhysicalProperties(6);
l3 = PhysicalProperties(7);

mt = m1 + m2 + m3;

cx1 = (m1/mt)*sin(th1)*l1/2;
cx2 = (m2/mt)*(sin(th1)*l1 + sin(th1 + th2)*l2/2);
cx3 = (m3/mt)*(sin(th1)*l1 + sin(th1 + th2)*l2 + sin(th1 + th2 + th3)*l3/2);

cz1 = (m1/mt)*cos(th1)*l1/2;
cz2 = (m2/mt)*(cos(th1)*l1 + cos(th1 + th2)*l2/2);
cz3 = (m3/mt)*(cos(th1)*l1 + cos(th1 + th2)*l2 + cos(th1 + th2 + th3)*l3/2);



cx = cx1 + cx2 + cx3;

cz = cz1 + cz2 + cz3;

end

