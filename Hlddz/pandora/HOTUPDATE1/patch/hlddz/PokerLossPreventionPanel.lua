PokerLossPreventionPanel = {}
local this = PokerLossPreventionPanel
PObject.extend(this)

function this.show( )
	print("PokerLossPreventionPanel show")
	PokerTempPanel.show("防流失面板展示", "确定",2)
end

function this.close( )
	print("PokerLossPreventionPanel close")
end