-- 
-- @file Menu.lua
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

require "Initialisation"
require "Util"
require "Entities"
require "ATH"
require "EnJeu"

EtatJeu = "Menu"
startTime = love.timer.getTime()
stime = love.timer.getTime()
bombTime = love.timer.getTime()
nbSeconde = 5

--- Affiche un bouton.
-- Si la souris est sur le bouton, un contour orange sera autour du bouton,
-- sinon un contour noir.
-- @param off Image du bouton avec le contour noir.
-- @param on Image du bouton avec le contour orange.
-- @param x Position x du bouton.
-- @param y Position y du bouton.
-- @param w Longeur du bouton.
-- @param h Largeur du bouton.
local function drawButton(off, on, x, y, w, h)
	love.graphics.setBackgroundColor( 190, 190, 190, 255 )
	local px = love.mouse.getX()
	local py = love.mouse.getY()
	if px > x and px < x + w and py > y and  py < y + h then
		love.graphics.draw(on, x, y)
	else
		love.graphics.draw(off, x, y)
	end
end

--- Gere les differents etat de jeu.
-- Etat de jeu : choix, pause, countdown, en jeu.
-- Dans cette fonction on a la gestion des menus et la gestion d'une partie.
function EtatJeuDraw()
	local x = love.mouse.getX( )
	local y = love.mouse.getY( )
   
	love.audio.play(musicMenu)
	if EtatJeu == "Menu" then
		love.mouse.setVisible(true)
		for k, v in pairs(Bouton.Main) do
			drawButton( v.Off, v.On, v.x, v.y, v.Width, v.Height, x, y )
		end
	end
   
	if EtatJeu == "Choix" then
		love.mouse.setVisible(true)
		for k, v in pairs(Bouton.Choix) do
			drawButton( v.Off, v.On, v.x, v.y, v.Width, v.Height, x, y )
		end
	end
   
	if EtatJeu == "Pause" then
		love.mouse.setVisible(true)
		for k, v in pairs(Bouton.Pause) do
			drawButton( v.Off, v.On, v.x, v.y, v.Width, v.Height, x, y )
		end
	end
	
	if EtatJeu == "Countdown" then
		love.mouse.setVisible(false)
		GroundDraw()
		Map()
		TankDraw()
		love.graphics.setFont(countdownFont)
		love.graphics.draw(Transparent, 0, 0, 0, Reso.Width/2, Reso.Height/2)
		love.graphics.printf(Countdown, Reso.Width / 2, Reso.Height / 2, 0, "center")
		love.graphics.setFont(normalFont)
	end

	if EtatJeu == "EnJeu" then
		EnJeu()
	end
	
    if love.mouse.isDown("l") then
		local dt2 = love.timer.getTime()
		if ((dt2 - Tank.Tir) > 1 / Tank.CadenceTir) then
			xMissile = Tank.Position.x + (Tank.TourelleImage:getWidth() - Tank.RotTourelleWidth) * math.cos(Tank.Angle.Tourelle)
			yMissile = Tank.Position.y + (Tank.TourelleImage:getWidth() - Tank.RotTourelleWidth) * math.sin(Tank.Angle.Tourelle)
			ents.Create("Missile", xMissile, yMissile)
			Tank.Tir = love.timer.getTime()
		end
    end
end

--- Verifie le clique souris.
-- Differente reaction en fonction de ou le joueur a clique;
-- par exemple, dans un menu, si le joueur clique sur "Jouer", alors on lance le jeu.
-- @param x Position x de la souris.
-- @param y Position y de la souris.
-- @param button Le bouton presse sur la souris.
function love.mousepressed(x, y, button )
	if button == "l" then
		if EtatJeu == "Menu" then
			for k, v in pairs(Bouton.Main) do
				if x > v.x and x < v.x + v.Width and y > v.y and  y < v.y + v.Height then
					if v.Id == "GoChoixTank" then
						love.audio.play(SonMenu2)
						EtatJeu = "Choix"
					elseif v.Id == "Quitter1" then
						love.event.push("quit")
					end
				end
			end
		elseif EtatJeu == "Choix" then
			for k, v in pairs(Bouton.Choix) do
				if x > v.x and x < v.x + v.Width and y > v.y and  y < v.y + v.Height then
					--> Si on choisit le Tank 1 <--
					if v.Id == "Tank1" then
						love.audio.play(SonMenu2)
						ChargerTank1()
						EtatJeu = "Countdown"
					end
					--> Si on choisit le Tank 2 <--
					if v.Id == "Tank2" then
						love.audio.play(SonMenu2)
						ChargerTank2()
						EtatJeu = "Countdown"
					end
					--> Si on choisit le Tank 3 <--
					if v.Id == "Tank3" then
						love.audio.play(SonMenu2)
						ChargerTank3()
						EtatJeu = "Countdown"
					end
					ents.objects = {}
				end
			end
		elseif EtatJeu == "Pause" then
			for k, v in pairs(Bouton.Pause) do
				if x > v.x and x < v.x + v.Width and y > v.y and  y < v.y + v.Height then
					if v.Id == "Reprendre" then
						love.audio.play(SonMenu2)
						EtatJeu = "EnJeu"
						--> Si on choisit le bouton menu du menu pause <--
					elseif v.Id == "Menu" then
						love.audio.play(SonMenu2)
						EtatJeu = "Menu"
						--> Si on choisit le bouton quitter du menu pause <--
					elseif v.Id == "Quitter2" then
						love.event.push("quit")
					end
				end
			end
		end
	end
end

--- Verifie les touches tape au clavier.
-- Si on clique sur Echappe pendant une partie, le jeu se met en pause.
-- Si on clique sur Echappe dans le menu pause, le jeu reprend.
-- @param key La touche tape sur le clavier.
function love.keypressed(key)
	if key == "escape" and EtatJeu=="EnJeu" then
		EtatJeu = "Pause"
	elseif key == "escape" and EtatJeu=="Pause" then
		EtatJeu = "EnJeu"
	end
end

--- Charge le tank 1.
function ChargerTank1()
	Tank.BaseImage = love.graphics.newImage("Images/BaseTank1.png")
	Tank.TourelleImage = love.graphics.newImage("Images/TourelleTank1.png")
	Tank.RotTourelleWidth = 89
	Tank.Vitesse = (Speed * 5)/7
	Tank.Dammage = 40
	Tank.Health = 225
	Tank.CadenceTir = 1.7
	Tank.Position.x = Reso.Width/2
	Tank.Position.y = Reso.Height/4 
	Tank.Angle.Base = 0
	Tank.Score = 0
end

--- Charge le tank 1.
function ChargerTank2()
	Tank.BaseImage = love.graphics.newImage("Images/BaseTank2.png")
	Tank.TourelleImage = love.graphics.newImage("Images/TourelleTank2.png")
	Tank.RotTourelleWidth = 103
	Tank.Vitesse = (Speed * 3)/7
	Tank.Dammage = 48
	Tank.Health = 360
	Tank.CadenceTir = 1.02
	Tank.Position.x = Reso.Width/2
	Tank.Position.y = Reso.Height/4 
	Tank.Angle.Base = 0
	Tank.Score = 0
end

--- Charge le tank 1.
function ChargerTank3()
	Tank.BaseImage = love.graphics.newImage("Images/BaseTank3.png")
	Tank.TourelleImage = love.graphics.newImage("Images/TourelleTank3.png")
	Tank.RotTourelleWidth = 50
	Tank.Vitesse = Speed
	Tank.Dammage = 24
	Tank.Health = 135
	Tank.CadenceTir = 2.38
	Tank.Position.x = Reso.Width/2
	Tank.Position.y = Reso.Height/4 
	Tank.Angle.Base = 0
	Tank.Score = 0
end
