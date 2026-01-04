# Swift Proto
Framework for protoc generated Swift files. `(protoc 3.19.4 and SwiftProtobuf 1.19.0 compiler)`

Proto files are from [`showproto`](https://git.csez.zohocorpin.com/zohoshow/showproto/) repo.

## How To
On Terminal, run the below command in root folder to generate Swift files.
```
sh generate showproto_directory_name
```

## Usage
`Proto.framework` is added to a project based on the below three options.

#### Shapes Proto Framework
* Application independent protos.
* Contains only shape related protos.
```
pod 'Proto/Shapes', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```

#### Show Proto Framework
* Contains protos for Show
* Includes `Proto/Shapes` framework
```
pod 'Proto/Show', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```

#### Startwith Proto Framework
* Contains protos for Startwith
* Includes `Proto/Shapes` framework
```
pod 'Proto/Startwith', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```

#### RemoteBoard Proto Framework
* Contains protos for RemoteBoard
* Includes `Proto/Shapes` framework
```
pod 'Proto/RemoteBoard', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```

#### Slate Proto Framework
* Contains protos for Slate
* Includes `Proto/Shapes` framework
```
pod 'Proto/Slate', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```

#### WhiteBoard Proto Framework
* Contains protos for WhiteBoard
* Includes `Proto/Shapes` framework
```
pod 'Proto/WhiteBoard', :git => 'https://git.csez.zohocorpin.com/zohoshow/apple/proto.git'
```
