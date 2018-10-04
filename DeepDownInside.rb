def hasEntitiesMethod(o)
  
  return (o.class.method_defined? :"entities")
end

def getAppropriateObject(obj)
  if(obj.instance_of? Sketchup::ComponentInstance)
    return obj.definition
else
    return obj 
  end
end

def printDict(dict)
  dict.keys.each{|key| puts(key)}
end

#def getChildren(ent)
#$reso=[];
#  if(mightHaveChildren(ent))
#    ent.entities.each{|kid|
#    
#  end
#end

$geometryAbst=[Sketchup::Face,Sketchup::Edge,Sketchup::Image]
$containerAbst=[Sketchup::Group,Sketchup::ComponentInstance,Sketchup::ComponentDefinition,Sketchup::Model,Sketchup::Selection,,Sketchup::Entities]
$guideAbstr=[Sketchup::ConstructionPoint,Sketchup::ConstructionLine]
$infoViewAbstr=[Sketchup::SectionPlane,Sketchup::Text,Sketchup::Dimension]

def isClassCategory(ent, arrOfClasses)
  return arrOfClasses.index(ent.class)!=nil
end

def isGeometry(ent)
  return isClassCategory(ent,$geometryAbst);
end

def isGuide(ent)
  return isClassCategory(ent,$guideAbstr)
end

def isContainer(ent)
  if(ent.is_a?Array)
    return true
  end
  return isClassCategory(ent,$containerAbst)
end

def isInfoView(ent)
  return isClassCategory(ent,$infoViewAbstr)
end

def filterDrawableType(entities,types)
  result=[]
  entities.each{|entity| 
  if(isClassCategory(entity,types))
    result.push(entity)
  end}
  return result  
end


def countEntities(entities, types)
  $sum=0
  entities.each{|entity|
    if(isClassCategory(entity,types))
      $sum+=1
    end
    if(isContainer(entity))
      toUse=getAppropriateObject(entity)
      $sum+=countEntities(toUse.entities,types)
    end
  }
  return $sum
end
def getEachable(ent)
   toEach=ent
    if(hasEntitiesMethod(ent))
      toEach=ent.entities
    end
    return toEach
end
def isOutlineLeafNode(ent)
  ent=getAppropriateObject(ent)
  if(isContainer(ent))
    eachable = getEachable(ent)
    eachable.each{|entity| 
      if(isContainer(entity))
        return false
      end
    }
  return true
  end
  return false
end

def mightHaveChildren(ent)
  $realEnt=getAppropriateObject(ent)
  $result=hasEntitiesMethod($realEnt);
  if($result)
    return true
  end
    return false
end
def iterateThroughChildren(ent)
  return _iterateThroughChildren(ent,[])
end
def _iterateThroughChildren(ent,resArr)
  realEnt=getAppropriateObject(ent)
  if(!isOutlineLeafNode(realEnt)&&isContainer(ent))
    toEach=getEachable(realEnt)
      toEach.each{|kid| _iterateThroughChildren(kid,resArr)}
  else if(isContainer(ent))
    resArr.push(ent)
    end
  end
  return resArr
end
