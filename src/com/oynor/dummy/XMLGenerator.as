package com.oynor.dummy {

	public class XMLGenerator {
		public function XMLGenerator() {
			throw new Error("XMLGenerator is static");
		}

		public static function generateRandomDepthXML(maxRootNodes : uint = 10, maxChildNodes : uint = 10, maxDepth : uint = 5) : XML {
			var xml : XML = <randomDepthXml></randomDepthXml>;
			
			// Generating a new root node
			maxRootNodes = Math.ceil(Math.random() * maxRootNodes);
			for (var curRootNodeIndex : uint = 0;curRootNodeIndex < maxRootNodes;curRootNodeIndex++) {
				var curRootNode : XML = <rootNode></rootNode>;
				curRootNode.@name = DummyStrings.getLipsumWord();
				
				// Generating a child node
				maxChildNodes = Math.ceil(Math.random() * maxChildNodes);
				for (var curChildNodeIndex : uint = 0;curChildNodeIndex < maxChildNodes;curChildNodeIndex++) {
					var curChildNode : XML = <childNode></childNode>;
					curChildNode.@name = DummyStrings.getLipsumWord();
					
					// Generating random number of child nodes under current child node
					var curMaxDepth : uint = Math.ceil(Math.random() * maxDepth);
					var curDepthNode : XML = curChildNode;
					for (var i : uint = 0;i < curMaxDepth;i++) {
						var depthNode : XML = <depthNode></depthNode>;
						depthNode.@name = DummyStrings.getLipsumWord();
							
						curDepthNode.appendChild(depthNode);
						curDepthNode = depthNode;
					}
						
					curRootNode.appendChild(curChildNode);
				}
				
				xml.appendChild(curRootNode);
			}
			
			return xml;
		}
	}
}