import CoreMotion


class MotionManager: ObservableObject, Equatable {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0
    
    @Published var topBackward = false
    @Published var topForward = false
    @Published var clockWise = false
    @Published var antiClock = false
    
    private var manager: CMMotionManager   //use iphone
//    private var manager: CMHeadphoneMotionManager  //use airpods


    init() {
        self.manager = CMMotionManager()    //use iphone
//        self.manager = CMHeadphoneMotionManager()   //use airpods
        
        self.manager.deviceMotionUpdateInterval = 0.01  //use iphone
        self.manager.startDeviceMotionUpdates(to: .main) { [self] (motionData, error) in guard error == nil else {
            print(error!)
            return
        }
            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                self.yaw = motionData.attitude.yaw
            }
        }
    }
    
    deinit {
        manager.stopDeviceMotionUpdates()
    }
    
    static func == (lhs: MotionManager, rhs: MotionManager) -> Bool {
        (lhs.topForward == rhs.topForward)
        && (lhs.topBackward == rhs.topBackward)
        && (lhs.antiClock == rhs.antiClock)
        && (lhs.clockWise == rhs.clockWise)
    }
}
