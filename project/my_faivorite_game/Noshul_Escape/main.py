import sys
import random
import os
from PyQt6.QtWidgets import QApplication, QWidget
from PyQt6.QtGui import QPainter, QColor, QFont, QPixmap, QTransform
from PyQt6.QtCore import Qt, QTimer, QRect, QUrl
from PyQt6.QtMultimedia import QMediaPlayer, QAudioOutput

class NoshulGame(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Побег от Панамаря: Definitive Edition")
        self.showFullScreen()
        
        self.base_path = os.path.dirname(os.path.abspath(__file__))
        self.assets_path = os.path.join(self.base_path, 'assets')
        
        self.keys_pressed = set()
        
        self.media_player = QMediaPlayer()
        self.audio_output = QAudioOutput()
        self.media_player.setAudioOutput(self.audio_output)
        music_path = os.path.join(self.assets_path, "music.mp3")
        self.media_player.setSource(QUrl.fromLocalFile(music_path))
        self.media_player.setLoops(QMediaPlayer.Loops.Infinite)
        self.audio_output.setVolume(1.0)
        
        self.music_enabled = True

        self.load_assets()
        
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_game)
        
        self.state = "START_MENU"
     
        self.btn_menu_rect = QRect(20, 20, 180, 50)
        self.btn_exit_rect = QRect(220, 20, 180, 50)
       
        self.char_list = [
            {"key": Qt.Key.Key_1, "name": "Макс", "img": self.img_max, "speed_mult": 1.0},
            {"key": Qt.Key.Key_2, "name": "Саня", "img": self.img_sanya, "speed_mult": 1.0},
            {"key": Qt.Key.Key_3, "name": "Глеб", "img": self.img_gleb, "speed_mult": 1.25},
            {"key": Qt.Key.Key_4, "name": "Дима", "img": self.img_dima, "speed_mult": 1.0}
        ]
        self.characters = {c["key"]: c for c in self.char_list}
        
        self.diff_list = [
            {"key": Qt.Key.Key_1, "name": "ЛАЙТ", "dist": 300, "speed": 10},
            {"key": Qt.Key.Key_2, "name": "БАЗА", "dist": 500, "speed": 14},
            {"key": Qt.Key.Key_3, "name": "ХАРДКОР", "dist": 800, "speed": 18},
            {"key": Qt.Key.Key_4, "name": "КОШМАР", "dist": 1000, "speed": 22}
        ]
        self.difficulties = {d["key"]: d for d in self.diff_list}
        self.d_data = self.diff_list[1] 
        
        self.reset_game()

    def load_assets(self):
        def load_pix(file_name, w=None, h=None):
            path = os.path.join(self.assets_path, file_name)
            pix = QPixmap(path)
            if pix.isNull():
                pix = QPixmap(100, 100)
                pix.fill(QColor(60, 60, 60))
            if w and h:
                return pix.scaled(w, h, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.SmoothTransformation)
            return pix

        self.img_bg = load_pix("bg.jpg")
        self.img_max = load_pix("max.png", 180, 240)
        self.img_sanya = load_pix("sanya.png", 180, 240)
        self.img_gleb = load_pix("gleb.png", 180, 240)
        self.img_dima = load_pix("dima.png", 180, 240)
        
        self.img_panamar = load_pix("panamar.png", 250, 330)
        self.img_panamar_mirrored = self.img_panamar.transformed(QTransform().scale(-1, 1))
        
        self.img_elk = load_pix("elk.png", 220, 220)
        self.img_rock = load_pix("rock.png", 100, 100)
        self.img_voda = load_pix("voda.png", 60, 100)

    def reset_game(self):
        self.ground_offset = 120
        self.player_velocity = 0
        self.panamar_velocity = 0
        self.gravity = 1.4 
        self.jump_power = -32
        self.is_jumping = False
        self.panamar_is_jumping = False
        self.player_x = 500
        self.panamar_x = -300 
        
        self.punishment_mode = False
        
        self.obstacles = []
        self.spawn_cooldown = 0
        self.panamar_bottles = 0 
        self.rage_timer = 0
        self.distance_traveled = 0
        self.debuff_timer = 0
        self.stumble_timer = 0
        
        self.base_speed = self.d_data["speed"]
        self.target_dist = self.d_data["dist"]
        
        self.player_rect = QRect(0, 0, 140, 200)
        self.panamar_rect = QRect(0, 0, 200, 300)

    def toggle_music(self):
        if self.music_enabled:
            self.media_player.pause()
            self.music_enabled = False
        else:
            if self.state == "PLAYING":
                self.media_player.play()
            self.music_enabled = True

    # --- Новое в коммите 7: Финальная реализация игрового движка обновления кадров ---
    def update_game(self):
        if self.state != "PLAYING": return

        # Проверка триггера победы по дистанции
        if self.distance_traveled >= self.target_dist:
            self.state = "WIN"
            self.timer.stop()
            self.media_player.stop()
            return

        ground_line = self.height() - self.ground_offset
        speed_boost = self.distance_traveled / 400
        default_speed = (self.base_speed + speed_boost) * self.p_data["speed_mult"]
        
        # Защита от обгона: переход Панамаря в режим наказания
        if self.panamar_x > self.player_x + self.player_rect.width() and not self.punishment_mode:
            self.punishment_mode = True
            self.panamar_x = self.player_x + 950 
            self.panamar_bottles = 10 
            self.rage_timer = 9999
            
            self.panamar_velocity = 0
            self.panamar_is_jumping = False
            self.panamar_rect.moveTop(int(ground_line - self.panamar_rect.height()))

        pan_speed = default_speed * 0.95
        
        if self.punishment_mode:
            pan_speed = -default_speed * 1.5 
        else:
            if self.panamar_bottles >= 10:
                if self.rage_timer == 0: self.rage_timer = 312 
                pan_speed = default_speed * 1.25
                self.rage_timer -= 1
                if self.rage_timer <= 0:
                    self.panamar_bottles = 0
                    self.rage_timer = 0

        world_move_speed = default_speed
        if self.stumble_timer > 0:
            self.stumble_timer -= 1
            world_move_speed = 0 
        elif self.debuff_timer > 0:
            self.debuff_timer -= 1
            world_move_speed = default_speed * 0.5 

        # Обработка горизонтального перемещения игрока
        if self.stumble_timer == 0:
            side_move = 12
            if Qt.Key.Key_Left in self.keys_pressed or Qt.Key.Key_A in self.keys_pressed:
                self.player_x -= side_move
            if Qt.Key.Key_Right in self.keys_pressed or Qt.Key.Key_D in self.keys_pressed:
                self.player_x += side_move
        
        self.player_x = max(0, min(self.width() - 150, self.player_x))
        
        # Рассчет относительного смещения Панамаря и счетчика пройденного пути
        self.panamar_x += (pan_speed - world_move_speed)
        if not self.punishment_mode and self.panamar_x < -400: 
            self.panamar_x = -400
            
        self.distance_traveled += world_move_speed / 40

        # Физика вертикальной оси игрока (Гравитация)
        self.player_velocity += self.gravity
        py = self.player_rect.top() + self.player_velocity
        if py >= ground_line - self.player_rect.height():
            py = ground_line - self.player_rect.height()
            self.is_jumping = False
            self.player_velocity = 0
        self.player_rect.moveTo(int(self.player_x), int(py))

        # ИИ Панамаря: автоматический прыжок через препятствия
        self.panamar_velocity += self.gravity
        for obs in self.obstacles:
            if self.punishment_mode: break
            
            dist_obs = obs['rect'].left() - self.panamar_rect.right()
            dist_plr = self.player_x - self.panamar_rect.right()
            if 0 < dist_obs < 250 and obs['type'] != 'voda' and not self.panamar_is_jumping:
                if dist_plr > 100: 
                    self.panamar_velocity = self.jump_power
                    self.panamar_is_jumping = True
                    
        pny = self.panamar_rect.top() + self.panamar_velocity
        if pny >= ground_line - self.panamar_rect.height():
            pny = ground_line - self.panamar_rect.height()
            self.panamar_is_jumping = False
            self.panamar_velocity = 0
        self.panamar_rect.moveTo(int(self.panamar_x), int(pny))

        # Рандомизированный спавн препятствий
        if self.spawn_cooldown > 0: self.spawn_cooldown -= 1
        if self.spawn_cooldown <= 0 and random.random() < 0.04:
            obj = random.choice(["rock", "elk", "voda"])
            size = {"rock": (100, 100), "elk": (220, 220), "voda": (60, 100)}[obj]
            img = {"rock": self.img_rock, "elk": self.img_elk, "voda": self.img_voda}[obj]
            r = QRect(self.width() + 150, ground_line - size[1], size[0], size[1])
            self.obstacles.append({'type': obj, 'rect': r, 'img': img})
            self.spawn_cooldown = random.randint(25, 50) 

        # Обработка движения препятствий и коллизий
        for obs in self.obstacles[:]:
            obs['rect'].moveLeft(int(obs['rect'].left() - world_move_speed))
            
            # Сбор святой воды Панамарем
            if not self.punishment_mode and self.panamar_rect.intersects(obs['rect']) and obs['type'] == 'voda':
                if self.panamar_bottles < 10: self.panamar_bottles += 1
                self.obstacles.remove(obs)
                continue
                
            if obs['rect'].right() < -300:
                self.obstacles.remove(obs)
            elif self.player_rect.intersects(obs['rect']):
                if obs['type'] == 'voda':
                    self.debuff_timer = 150
                    self.obstacles.remove(obs)
                else:
                    self.stumble_timer = 60
                    self.obstacles.remove(obs)

        # Вычисление условий Game Over (поимка игрока)
        is_caught = self.player_rect.intersects(self.panamar_rect)
        if self.punishment_mode and self.panamar_rect.left() <= self.player_rect.right():
            is_caught = True

        if is_caught:
            self.state = "GAME_OVER"
            self.timer.stop()
            self.media_player.stop()
        
        self.update()
    # -----------------------------------------------------------------------------

    def draw_ui_buttons(self, qp):
        qp.setPen(Qt.GlobalColor.white)
        qp.setBrush(QColor(50, 50, 50, 200))
        qp.drawRoundedRect(self.btn_menu_rect, 10, 10)
        qp.setFont(QFont("Verdana", 14, QFont.Weight.Bold))
        qp.drawText(self.btn_menu_rect, Qt.AlignmentFlag.AlignCenter, "В МЕНЮ [B]")

        qp.setBrush(QColor(150, 30, 30, 200))
        qp.drawRoundedRect(self.btn_exit_rect, 10, 10)
        qp.drawText(self.btn_exit_rect, Qt.AlignmentFlag.AlignCenter, "ВЫХОД [ESC]")
        qp.setBrush(Qt.BrushStyle.NoBrush)

    def paintEvent(self, event):
        qp = QPainter(self)
        qp.setRenderHint(QPainter.RenderHint.SmoothPixmapTransform)
        qp.drawPixmap(self.rect(), self.img_bg)
        
        if self.state == "START_MENU":
            self.draw_start_menu(qp)
        elif self.state == "DIFFICULTY_SELECT":
            self.draw_diff_menu(qp)
        elif self.state == "CHAR_SELECT":
            self.draw_char_menu(qp)
        elif self.state in ["PLAYING", "GAME_OVER", "WIN"]:
            qp.drawPixmap(self.player_rect, self.p_data["img"])
            
            panamar_sprite = self.img_panamar_mirrored if self.punishment_mode else self.img_panamar
            qp.drawPixmap(self.panamar_rect, panamar_sprite)
            
            if self.panamar_bottles >= 10:
                qp.fillRect(self.panamar_rect, QColor(255, 0, 0, 80)) 
                
            for obs in self.obstacles:
                qp.drawPixmap(obs['rect'], obs['img'])
            
            qp.setPen(Qt.GlobalColor.white)
            qp.setFont(QFont("Verdana", 20, QFont.Weight.Bold))
            qp.drawText(50, 60, f"БОЕЦ: {self.p_data['name']} | СЛОЖНОСТЬ: {self.d_data['name']} | ДИСТАНЦИЯ: {int(self.distance_traveled)}/{self.target_dist} м")
            
            if self.punishment_mode:
                qp.setPen(Qt.GlobalColor.red)
                qp.drawText(50, 100, "БАЗА ДАННЫХ ПОВРЕЖДЕНА! ПАНАМАРЬ ВЗЛОМАЛ КОД!")
            elif self.panamar_bottles >= 10:
                qp.setPen(Qt.GlobalColor.red)
                timeLeft = self.rage_timer // 60 + 1
                qp.drawText(50, 100, f"ПАNAMАРЬ В ЯРОСТИ! ({timeLeft} сек)")
            else:
                qp.setPen(Qt.GlobalColor.white)
                qp.drawText(50, 100, f"СВЯТОЙ ВОДЫ У ПАНАМАРЯ: {self.panamar_bottles}/10")
            
            if self.state == "GAME_OVER":
                qp.fillRect(self.rect(), QColor(0, 0, 0, 200))
                qp.setPen(Qt.GlobalColor.red)
                
                if self.punishment_mode:
                    qp.setFont(QFont("Impact", 65))
                    qp.drawText(self.rect(), Qt.AlignmentFlag.AlignCenter, f"НЕ\nЭТО ТАК НЕ РАБОТАЕТ\nENTER или B - В МЕНЮ")
                else:
                    qp.setFont(QFont("Impact", 80))
                    qp.drawText(self.rect(), Qt.AlignmentFlag.AlignCenter, f"СКРУЧЕН ПАНАМАРЕМ!\nENTER или B - В МЕНЮ")
                
                self.draw_ui_buttons(qp)
                    
            elif self.state == "WIN":
                qp.fillRect(self.rect(), QColor(0, 0, 0, 180))
                qp.setPen(QColor("gold"))
                qp.setFont(QFont("Impact", 70))
                win_text = f"Это еще не конец.\nНу {self.p_data['name']}, погоди!"
                qp.drawText(self.rect(), Qt.AlignmentFlag.AlignCenter, win_text)
                self.draw_ui_buttons(qp)

    def draw_start_menu(self, qp):
        qp.fillRect(self.rect(), QColor(0, 0, 0, 170))
        qp.setPen(Qt.GlobalColor.white)
        qp.setFont(QFont("Impact", 95))
        qp.drawText(0, 150, self.width(), 120, Qt.AlignmentFlag.AlignCenter, "НОШУЛЬ: ПОБЕГ")
        
        qp.setFont(QFont("Verdana", 28))
        qp.drawText(0, 350, self.width(), 60, Qt.AlignmentFlag.AlignCenter, "Нажми [SPACE], чтобы начать")
        
        qp.setFont(QFont("Verdana", 18))
        controls_y = self.height() - 250
        qp.drawText(0, controls_y, self.width(), 40, Qt.AlignmentFlag.AlignCenter, "УПРАВЛЕНИЕ: WASD или СТРЕЛКИ | ПРЫЖОК: SPACE")
        
        music_status = "ВКЛ" if self.music_enabled else "ВЫКЛ"
        qp.setPen(QColor("yellow") if self.music_enabled else QColor("gray"))
        qp.drawText(0, controls_y + 50, self.width(), 40, Qt.AlignmentFlag.AlignCenter, f"МУЗЫКА [M]: {music_status}")
        
        qp.setPen(Qt.GlobalColor.gray)
        qp.drawText(0, controls_y + 120, self.width(), 40, Qt.AlignmentFlag.AlignCenter, "ESC - ВЫХОД ИЗ ИГРЫ")

    def draw_diff_menu(self, qp):
        qp.fillRect(self.rect(), QColor(0, 0, 0, 190))
        self.draw_ui_buttons(qp)
        
        qp.setPen(Qt.GlobalColor.white)
        qp.setFont(QFont("Impact", 70))
        qp.drawText(0, 100, self.width(), 100, Qt.AlignmentFlag.AlignCenter, "ВЫБЕРИ СЛОЖНОСТЬ")
        
        start_y = 300
        spacing = 100
        for i, diff in enumerate(self.diff_list):
            y = start_y + i * spacing
            qp.setPen(QColor("yellow"))
            qp.setFont(QFont("Impact", 45))
            qp.drawText(0, y, self.width(), 60, Qt.AlignmentFlag.AlignCenter, f"[{i+1}] {diff['name']} ({diff['dist']} м, СК: {diff['speed']})")

    def draw_char_menu(self, qp):
        qp.fillRect(self.rect(), QColor(0, 0, 0, 190))
        self.draw_ui_buttons(qp)
        
        qp.setPen(Qt.GlobalColor.white)
        qp.setFont(QFont("Impact", 70))
        qp.drawText(0, 100, self.width(), 100, Qt.AlignmentFlag.AlignCenter, "ВЫБЕРИ БОЙЦА")
        card_w, card_h = 300, 450
        spacing = 60
        start_x = (self.width() - (card_w * 4 + spacing * 3)) // 2
        for i, char in enumerate(self.char_list):
            x = start_x + i * (card_w + spacing)
            y = 350
            qp.setPen(QColor(255, 255, 255, 80))
            qp.drawRect(x, y, card_w, card_h)
            pix = char["img"].scaled(220, 300, Qt.AspectRatioMode.KeepAspectRatio)
            qp.drawPixmap(x + (card_w - pix.width()) // 2, y + 40, pix)
            qp.setPen(Qt.GlobalColor.white)
            qp.setFont(QFont("Verdana", 22, QFont.Weight.Bold))
            qp.drawText(x, y + 360, card_w, 40, Qt.AlignmentFlag.AlignCenter, char["name"])
            qp.setPen(QColor("yellow"))
            qp.drawText(x, y + 400, card_w, 40, Qt.AlignmentFlag.AlignCenter, f"Жми [{i+1}]")

    def mousePressEvent(self, event):
        if event.button() == Qt.MouseButton.LeftButton:
            pos = event.pos()
            if self.state in ["DIFFICULTY_SELECT", "CHAR_SELECT", "GAME_OVER", "WIN"]:
                if self.btn_exit_rect.contains(pos):
                    self.close()
                elif self.btn_menu_rect.contains(pos):
                    self.state = "START_MENU"
                    self.update()

    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key.Key_Escape: self.close()
        if key == Qt.Key.Key_M: self.toggle_music()
        if key == Qt.Key.Key_B and self.state in ["DIFFICULTY_SELECT", "CHAR_SELECT", "GAME_OVER", "WIN"]:
            self.state = "START_MENU"
            self.update()
            return
        
        self.keys_pressed.add(key)

        if self.state == "START_MENU" and key == Qt.Key.Key_Space:
            self.state = "DIFFICULTY_SELECT"
            
        elif self.state == "DIFFICULTY_SELECT" and key in self.difficulties:
            self.d_data = self.difficulties[key]
            self.state = "CHAR_SELECT"
            
        elif self.state == "CHAR_SELECT" and key in self.characters:
            self.p_data = self.characters[key]
            self.state = "PLAYING"
            self.reset_game()
            if self.music_enabled:
                self.media_player.play()
            self.timer.start(16)
            
        elif self.state == "PLAYING":
            if key in [Qt.Key.Key_Space, Qt.Key.Key_Up, Qt.Key.Key_W] and not self.is_jumping and self.stumble_timer == 0:
                self.player_velocity = self.jump_power
                self.is_jumping = True
                
        elif self.state in ["GAME_OVER", "WIN"] and key in [Qt.Key.Key_Return, Qt.Key.Key_Enter]:
            self.state = "START_MENU"
            
        self.update()

    def keyReleaseEvent(self, event):
        if event.key() in self.keys_pressed:
            self.keys_pressed.remove(event.key())

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = NoshulGame()
    ex.show()
    sys.exit(app.exec())