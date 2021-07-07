
import UIKit


public class Sector:UIView{
    
    public var text: String = "1"
    public var sectorColor = UIColor.red
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        let color = sectorColor
        color.set() // 设置线条颜色
        
        //用贝塞尔曲线画一个扇形
        let aPath = UIBezierPath(arcCenter: centerPoint, radius: radius,
                                 startAngle:CGFloat(0-Double.pi/2-angle/2), endAngle: CGFloat(0-Double.pi/2+angle/2), clockwise: true)
        aPath.addLine(to:centerPoint)
        aPath.close()
        aPath.lineWidth = 2.0 // 线条宽度
        
        aPath.stroke() // Draws line 根据坐标点连线，不填充
        //aPath.fill() // Draws line 根据坐标点连线，填充
        
        //填充文字
        let label = UILabel(frame: CGRect(x: radius.double-10, y: angle/2+10, width: 30, height: 30))
        label.text = text
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        addSubview(label)
        
    }
    
    public func rotate(_ angle:CGFloat){

        transform = CGAffineTransform(rotationAngle: angle)

        
    }
}

