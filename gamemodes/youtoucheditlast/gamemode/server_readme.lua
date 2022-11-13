--[[ 

Hello! It seems you've learned how to extract .gma files! No worries, it's all good. In here I will tell you a bit about how
you can costumize your server with custom gametypes and balls as well as other settings.


	In the gamemode you will find a file called "costumizeserver.lua". This is the main file for costumizing and adding balls.
	"gametypes.lua" is the file in which all the rules of each gametype is defined. Copy-paste one of them and edit it to your liking
	and the gamemode should automatically load it in. Just be sure to increment the number at the start!!!

	On to costumizeserver.lua. In this file you will find 3 things:
		1) The list of balls. Use this to add your own!
		2) The order of which ytil_gametypecycle works
		3) Space to put your own hooks and functions (example at the bottom)

		
	At the very top of the file you will see a function you can use to check if a player is in a steam group. Its argument is
	the part of the URL to your steam group, the id.	
			
		
	Below that you will see the table 'ytil_BallList'. This is the table you can use to add your own balls!
	All you have to do is to copy-paste this template and edit it to your liking, then put it in:
	
	[4] = {																<-- Increment this number as you add balls, the ID of the ball
		name = "Some Name",												<-- The name to display in console
		condition = function(ply)
		
			A function with 1 argument: the player looking to unlock the ball. Return true to unlock, false otherwise.
			Here's a couple of examples:
			
			return true 												<-- Always unlocked
			return ply.SomeCondition									<-- Unlocks if SomeCondition is true on that player
			return ply:IsInSteamGroup( id )								<-- Unlocks if player is in that steam group
			return ply:PS_HasItem( item_id )							<-- Unlocks if player has a certain Pointshop 1 item
			
			for k,v in pairs(ply.PS2_Inventory:getItems()) do
				if instanceOf(KInventory.Items.youritemhere, v) then
					return true											<-- Unlocks if player has at least one specific custom Pointshop 2 item
				end
			end
			
		end,
		texture = Material( "your/texture/path/here" ), 				<-- Texture path of the ball. Should be .vmt and .vtf format
		sound = Sound( "your/soundpath/here.wav" ), 					<-- The sound it makes on bouncing.
		offsetX = -4, 													<-- Offset of the ball texture in the View Model, X-axis
		offsetY = 1,													<-- Same as above, Y-axis, use these two to make it fit the hand holding it in first person
		killSound = nil,												<-- Sound used in Death when it kills a player, nil for no sound (like normal)
		effect = "ball_explosion_main",									<-- Explosion particle, this is the default one
		explosionsound = "youtoucheditlast/ball_explosion.wav",			<-- Explosion sound, this is the default one
		delay = 0,														<-- Delay before the damage occurs from the explosion, useful for effects with brief implosions/charges
		shakedur = 2,													<-- Duration of explosion shake
		shakeamp = 20,													<-- Amplifier of explosion shake
		shakefreq = 5													<-- Frequency of explosion shake
	},

	
	
	It may look like a lot, but take it one by one and it shouldn't be so hard.
	In the file you can see the actual table. Ball 1 is the default one, Ball 2 is the Pixel ball for our steam group, and 3 is the beta tester ball.
	
					I ask of you, that you do not use the textures, sounds, and unique explosions of balls 2 and 3.
								(Except the default explosion, which the Pixel uses)
	
	!!! I HIGHLY recommend you ONLY add different explosion effects to exclusive/expensive balls, to keep a sense of value to them !!!
						The more custom sounds, effects, and textures you add, the more rarity/value the ball should have
										Animated textures should only be on highly exclusive balls
										
										
										
	
	
	Down under that is the table that the gametype cycling cycles through.
	The mode numbers are as follows:
	1 = "Free For All"
	2 = "Bomb"
	3 = "Infection"
	4 = "Infection Bomb"
	5 = "Hunt"
	6 = "Death"
	7 = "Angelic"

	{mode = the gametype number (from above)}
	{rounds = the number of rounds before it cycles on}
	{bomb = manually enable the bomb on non-bomb gametypes. You don't need to do this in the actual bomb modes}
	{bombmintime = if set, will change the minimum bomb time when it cycles to here. This number stays until you change it back later}
	{bombmaxtime = if set, will change the maximum bomb time when it cycles to here. This number stays until you change it back later}
	
	
	
	Under this is the admin priviledges function the gamemode uses. Use this to add your own admin checks if you are running
	different admin mods. This function is what allows the editing in the F1 menu and forcing votes and roles.
	
	Here is an example that will use your own RTV instead of the round cycle when max rounds has been reached. You can add these
	into costumizeserver.lua as well.
	
	hook.Add("ytil_MaxRoundsReached", "MyOwnRTV", function()
		YOUR RTV CODE HERE
		Call "RoundRestart(mode number)" to change the mode
		return true		<-- Stops the normal cycle from running
	end)

	
]]