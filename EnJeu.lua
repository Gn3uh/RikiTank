-- 
-- @file EnJeu.lua
-- This file is a part of RikiTank project, an amazing tank game !
-- Copyright (C) 2012  Riki-Team
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 

startTime = love.timer.getTime()
stime = love.timer.getTime()
bombTime = love.timer.getTime()
nbSeconde = 5

--- Le jeu se deroule ici.
-- C'est la boucle qui fait tourner la partie,
-- utilisation de variable de temps pour l'apparition des ennemis a certain intervalle de temps.
-- On cree les ennemis ici, on dessine l'ATH et le tank.
-- Si la partie est termine, le contenu du tableau d'objets est efface, on lance le game over.
function		EnJeu()
	love.audio.stop(musicMenu)
	love.mouse.setVisible(false)
	GroundDraw()						-- on affiche le sol du jeu
	ents:draw()
	if Tank.Health > 0 then
		-- Timer pour l'apparition des ennemis
		local etime = love.timer.getTime()
		local bombCheck = love.timer.getTime()
		
		if etime - stime > nbSeconde then
			local xTE, yTE = getRandomCoord()
			ents.Create("TankEnnemie", xTE, yTE)
			local xWalker, yWalker = getRandomCoord()
			ents.Create("Walker", xWalker, yWalker)
			stime = love.timer.getTime()
		end
		
		-- Apres 3 minutes de jeu, l'apparition des ennemis est plus rapide
		if etime - startTime > 180 then
			nbSeconde = 3
		end
		--[[if bombCheck - bombTime >= 23 then
			bombTime = love.timer.getTime()
			ents.Create("Bomb", 400, 400)
		end]]
		TankDraw()
		ATH_Life()
	else
		ents.objects = {}
		FinPartie()
	end
end

--- Affichage du game over.
function		FinPartie()
	love.graphics.setFont(countdownFont)
	love.graphics.draw(Transparent, 0, 0, 0, Reso.Width/2, Reso.Height/2)
	love.graphics.draw(GameOver, Reso.Width/2, Reso.Height/1.8, 0, 1, 1, GameOver:getWidth()/2, GameOver:getHeight()/2)
	love.graphics.printf("Score " .. Tank.Score, Reso.Width / 2, Reso.Height / 30, 0, "center")
	love.graphics.setFont(normalFont)
end