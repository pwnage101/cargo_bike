line_num = 43
angle = 15

line_num +=1
angle += 10
App.ActiveDocument.Sketch.addGeometry(Part.LineSegment(App.Vector(21.082108,24.860069,0),App.Vector(28.842909,34.049236,0)),False)
App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('PointOnObject',line_num,1,40)) 
App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('PointOnObject',line_num,2,41)) 
App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('Perpendicular',40,line_num)) 
App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('Angle',22,1,line_num,1,App.Units.Quantity('{}.00000 deg'.format(angle)))) 


for angle in range(1,90):
    if angle not in [n*5 for n in range(1, 20)]:
        line_num +=1
        App.ActiveDocument.Sketch.addGeometry(Part.LineSegment(App.Vector(21.082108,24.860069,0),App.Vector(28.842909,34.049236,0)),False)
        App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('PointOnObject',line_num,1,38)) 
        App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('PointOnObject',line_num,2,39)) 
        App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('Perpendicular',38,line_num)) 
        App.ActiveDocument.Sketch.addConstraint(Sketcher.Constraint('Angle',22,1,line_num,1,App.Units.Quantity('{}.00000 deg'.format(angle)))) 
