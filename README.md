# elmGameAnimation
关于底层框架
Event->Messages-> (Move, Animation)
（这些不都是实际中代码实现的类，只是一个流程图）
Event可以是玩家的键盘鼠标输入，也可以是游戏中的event，比如发生了碰撞。
Messages需要包含所有改变Action必要的信息。比如说要改变哪一个物体。
Action则包含Geometry和Animation两部分，这两部分分别是干啥的将在下文详细说明。
游戏所有的动画展示都放在Update.elm的gameDisplay下面。
其完整流程如下：
1.	检测Event是否发生。
比如我现在的7月1日上传的代码里，model.passedTime >= 100 就可以被看作一个event，当该event发生之时，使用genAniMsg函数产生一个AnimationMsg类的变量（在7月1日的例子中，该变量名叫做aniMsg）。

2.	将该aniMsg发给相应的gameobject，由gameobject的changeAction函数接收这个aniMsg的index值（该值指定了要做哪一个动作，比如一个gameobject可以有唱，跳，rap，篮球四个action，aniMsg中的index值指定了目标动作在gameobject的actions里的下标，比如1就是唱，2就是跳），指定好动作之后，再将AniMsg交给act这个函数处理，receiveAniMsg函数接收，receiveAniMsg用于将AniMsg中除了index之外的值发给gameobject，更改属性
3.	更改好属性之后，就会执行doAnimation函数，这个函数将会根据属性来播放动画。

该框架中最基本的类是GameObject
它由两部分构成
一部分是它的几何判定区域(Geometry)，包括长宽，中心坐标，还有旋转角度（一般来说我们用矩形尤其是正方形来作为几何判定区域的形状）
另一部分是其贴图的变换。贴图的变换被称作Action，Action是Animation类的，比如一个人物“向左走”就是一个Action，是一个Animation类的变量。
Animation（动画）类包含一个srcLib，即图形库（完成该动画所需要的所有贴图），srcLib的类型是一个List String（字符串列表）用来存放所有图形的路径。有一个loop的布尔值，用处是用于判断以何种方式播放动画（loop==true，就循环播放，不然就只播放一次）（loop与否的信息需要被包含在Messages里面）

目前Geometry与Animation都已经实现。
