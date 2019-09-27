import  UIKit
public class Disk:UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var section_num=0
    public var text:[String]=["1","2"]
    var sections:[Sector]?=nil
    

    public func initSectors(){
        //清楚之前的
        for subview in subviews{
            subview.removeFromSuperview()
        }
        sections?.removeAll()
        //新的扇形
        section_num=text.count
        angle = Double.pi*2/section_num.double
        for i in 0...section_num-1{
            
            let sector = Sector(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
            //sector.sectorColor = ( i%2 == 0 ? MTTheme.getMainColor():UIColor.gray)
            sector.sectorColor=MTTheme.getMainColor()
            sector.text=text[i]
            sector.setNeedsDisplay()
            addSubview(sector)
            sector.rotate(CGFloat(angle*i.double))
            sections?.append(sector)
        }
    }
    public func startRotate(rotateAngle:CGFloat){
        let ani=CABasicAnimation(keyPath: "transform.rotation.z")
        ani.duration=5
        ani.toValue=rotateAngle
        ani.repeatCount=1
        ani.isRemovedOnCompletion=false
        ani.fillMode = CAMediaTimingFillMode.forwards
        ani.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(ani, forKey: "test")
        
    }
    
}

