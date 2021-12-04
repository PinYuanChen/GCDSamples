
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//         simpleQueues()
        
//         queuesWithQoS()
        
        /*
         concurrentQueues()
         if let queue = inactiveQueue {
            queue.activate()
         }
         */
        
//         queueWithDelay()
        
         fetchImage()
        
         useWorkItem()
    }
    
    
    
    func simpleQueues() {
        let queue = DispatchQueue(label: "com.patrick.myqueue")
        
        /*
        queue.sync {
            for i in 0..<10 {
                print(i)
            }
        }
        */
        
        queue.async {
            for i in 0..<10 {
                print(i)
            }
        }
        
        for i in 100..<110 {
            print("Ⓜ️", i)
        }
    }
    
    
    func queuesWithQoS() {
        
        /*
         .userInitiated 比 .utility先跑，因為級別較高
         .background 比 .utility先跑完，與文章不同
         主線程 > .userInitiated > .utility
         */
        
//        let queue1 = DispatchQueue(label: "com.patrick.queue1",
//                                   qos: .background)
        let queue1 = DispatchQueue(label: "com.patrick.queue1",
                                   qos: .userInitiated)
//        let queue2 = DispatchQueue(label: "com.patrick.queue2",
//                                   qos: .userInitiated)
        let queue2 = DispatchQueue(label: "com.patrick.queue2",
                                   qos: .utility)
        
        queue1.async {
            for i in 0..<10 {
                print("📣",i)
            }
        }
        
        queue2.async {
            for i in 100..<110 {
                print("🔊", i)
            }
        }
        
        for i in 1000..<1010 {
            print("Ⓜ️", i)
        }
    }
    
    
    var inactiveQueue: DispatchQueue!
    func concurrentQueues() {
        /*
          .concurrent印出來會按照順序
         [.initiallyInactive, .concurrent] 會印三、二、ㄧ
         */
        
//        let anotherQueue = DispatchQueue(label: "com.patrick.anotherQueue",
//                                         qos: .utility,
//                                         attributes: .concurrent)
        
        let anotherQueue = DispatchQueue(label: "com.patrick.anotherQueue",
                                         qos: .utility,
                                         attributes: [.initiallyInactive, .concurrent])
        inactiveQueue = anotherQueue
        
        anotherQueue.async {
            for i in 0..<10 {
                print("📣",i)
            }
        }
        
        anotherQueue.async {
            for i in 100..<110 {
                print("🔊", i)
            }
        }
        
        anotherQueue.async {
            for i in 1000..<1010 {
                print("Ⓜ️", i)
            }
        }
        
    }
    
    
    func queueWithDelay() {
        let delayQueue = DispatchQueue(label: "com.patrick.delayqueue", qos: .userInitiated)

        print(Date())

        delayQueue.asyncAfter(deadline: .now() + 2.0) {
            print(Date())
        }
    }
    
    
    func fetchImage() {
        let imageURL: URL = URL(string: "https://as2.ftcdn.net/v2/jpg/04/39/75/91/1000_F_439759107_PZHtjldln6bv18dQsE99L63JbHbGjgyz.jpg")!

            (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: { (imageData, response, error) in

                if let data = imageData {
                    print("Did download image data")
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }).resume()
    }
    
    
    func useWorkItem() {
        var value = 10
        let queue = DispatchQueue.global()
        
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        /*
         queue.async {
         workItem.perform()
         }
         */
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }
}

