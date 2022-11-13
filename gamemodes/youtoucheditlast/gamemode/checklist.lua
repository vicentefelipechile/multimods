--[[ Things to fix:
	
	✓ 	 = Done
	-	 = Not Done
	?	 = Needs Testing
	X	 = Decided not to implement
	/	 = Couldn't do

	✓ Team numbers (TEAM_CONNECTING = 0, conflict: causes grey scoreboard colors)
	✓ Infection ball regain: Does not show viewmodel
	✓  Timer bug, not showing up for certain people? (REPLICATED CONVARS NOT REPLICATING) Doesn't seem to exist any fix - game bug
	✓ Multi-explosion killing other infected: Lua errors (Player is dead, need IsValid)
	✓ Point system for all modes
	✓ Test Death mode, fix spectating
	✓ Implement AFK spectating + Spectate Menu/List
	- Make all variables below configurable (Maybe for a later update)
	✓ Make starting gametype setting actually work
	✓ Fancy menu picture and icon
	- Workshop pictures & video (Playtesting)
	✓ Pixel bouncy balls
	✓ End infected bomb with huge explosion
	✓ Infected color scheme? (Maybe infected black, additional color to differentiate?)
	- NEW MODE: Angelic (Name WIP), Freeze Tag but with a ball, 1 that freezes (used by 1 enemy), and 1 that unfreezes (used by the rest) (Maybe in later update)
	✓ Make a fancy admin panel for selecting gamemodes/Restarting round
	✓ Make the same fancy panel for non-admins to vote on a mode change
	✓ NetworkVars instead of Net Messages
	✓ Cheeky Self-Promotion
	
	UPDATE CHANGES:
	✓ Make F1 Menu appear when joining first
	? Fix massive explosion crash
	✓ Remove explosion sound and shake from player explosions (multiple sounds are wierd)
	✓ Fix being able to join back from being dead in Death
	/ Use the net messages to do proper non-laggy spectating from dying instead (Seems to be tied to being dead or not)
		Apparently it feels choppy if you're dead according to the game (DEAD in chat)
	? Fix balls sometimes not being able to be retrieved
	✓ Increase blast damage radius
	
	UPDATE 2:
	✓ Make Left Click able to break windows and other breakable stuff
	✓ Make a name appear when you look at someone
	X Make a name appear when you look at someone's ball
	✓ Add Addi to the beta tester list
	✓ Scale HUD correctly
	✓ Add progress bar to recovering ball from right click
	X Add "Start with X gametype"-settings to the main menu?
	✓ Set charge speed to 2
	✓ Better fall damage
	
	UPDATE 3:
	✓ Gametype cycling (for servers)
		✓ Round counter
		✓ Cycle order
		✓ ConVar
	✓ Manual bomb enable ConVar + F1 menu option + New generic explosion texture
		✓ ConVar + logic
		✓ F1 Menu option
		✓ Generic explosion texture (rendered behind gametype icon)
	✓ Ball texture table collection - all in one new file
		✓ Provice example for Pointshop 1 & 2
	✓ Death ball makes you fly away
	? ANGELIC gametype!
	✓ Spectator teleport buttons
	✓ GM.Info
	
	✓ Spectator Chasing mode
	✓ Fix/test spectating
	✓ Test gametype voting
	✓ Alternative IsSuperAdmin function
	✓ Convar for time to teleport ball
	✓ Collect Gametype rules in a single table
	
	✓ Spectating IsValids
	✓ Mode votes cancel on disconnect
	✓ Spectators unable to move items
	✓ Round restart timer name correction
	
]]