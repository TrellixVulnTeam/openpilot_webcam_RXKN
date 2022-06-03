import rospy
from std_msgs.msg import String, Float32


class MYROS():
    def __init__(self):
        rospy.init_node('listener', anonymous=True)
        #self.speedpub = rospy.Publisher('Wheel_Speed_RL', Float32, queue_size=10)
        #self.anglepub = rospy.Publisher('Angle', Float32, queue_size=10)
        
    def spin(self):
        rospy.spin()


    def speed_callback(self, speed_callback):
        rospy.Subscriber('/Wheel_Speed_RL', Float32, speed_callback)

    def imu_callback(self, imu_calllback):
        rospy.Subscriber('get_imu', String, imu_callback)


    def set_speed(self, speed):
        self.speedpub.publish(speed)
        
    
    def set_angle(self, angle):
        self.anglepub.publish(angle)


    def listener():

        # In ROS, nodes are uniquely named. If two nodes with the same
        # name are launched, the previous one is kicked off. The
        # anonymous=True flag means that rospy will choose a unique
        # name for our 'listener' node so that multiple listeners can
        # run simultaneously.
        rospy.init_node('listener', anonymous=True)

        rospy.Subscriber('chatter', String, callback)
        print("test")
        # spin() simply keeps python from exiting until this node is stopped
        rospy.spin()