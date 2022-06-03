import myros



def callback(data):
    rospy.loginfo('I heard %s', data.data)

if __name__ == '__main__':
    r = myros.MYROS()
    r.speed_callback(callback)
    r.spin()