require "PokerLossPreventionPanel"

PokerLossPreventionCtrl = {}
local this = PokerLossPreventionCtrl
PObject.extend(this)

local openLossPreventionJson = "{\"type\":\"lossprevention_iconstate\",\"content\":\"open\"}"
    

function this.init()
	Log.i("PokerLossPreventionCtrl init")
	Pandora.callGame(openLossPreventionJson)
end

function this.show( )
	Log.i("PokerLossPreventionCtrl show")
	PokerLossPreventionPanel.show()
end

function this.close( )
	Log.i("PokerLossPreventionCtrl close")
	PokerLossPreventionPanel.close()
end