# -*- coding: utf-8 -*-
"""
生成 DeepSeek-iOS 的 App 图标 1024x1024。
设计：深蓝渐变底 + 白色圆角对话气泡 + 内部星火（DeepSeek 品牌感）。
不使用任何外部字体/素材，全部几何绘制，保证干净无版权问题。
"""
import math
from PIL import Image, ImageDraw, ImageFilter

S = 1024
SS = 4  # 超采样倍数，抗锯齿
W = S * SS

img = Image.new("RGB", (W, W), "#0B1B3A")
draw = ImageDraw.Draw(img)

# ---------- 1. 背景渐变 (对角，深蓝 -> 亮青蓝) ----------
top = (14, 32, 71)      # #0E2047
bottom = (30, 96, 176)  # #1E60B0
for y in range(W):
    t = y / (W - 1)
    # 稍微用一点 ease，让亮色集中在下半部
    t2 = t ** 1.25
    r = int(top[0] + (bottom[0] - top[0]) * t2)
    g = int(top[1] + (bottom[1] - top[1]) * t2)
    b = int(top[2] + (bottom[2] - top[2]) * t2)
    draw.line([(0, y), (W, y)], fill=(r, g, b))

# ---------- 2. 右上角光晕 ----------
glow = Image.new("L", (W, W), 0)
gd = ImageDraw.Draw(glow)
cx, cy = int(W * 0.78), int(W * 0.18)
rad = int(W * 0.42)
for i in range(rad, 0, -1):
    a = int(90 * (1 - i / rad) ** 2)
    gd.ellipse([cx - i, cy - i, cx + i, cy + i], fill=a)
glow = glow.filter(ImageFilter.GaussianBlur(W * 0.03))
img = Image.composite(Image.new("RGB", (W, W), "#3FA9F5"), img, glow)
draw = ImageDraw.Draw(img)

# ---------- 3. 对话气泡（白色圆角矩形 + 左下小尾巴） ----------
bw, bh = int(W * 0.56), int(W * 0.42)
bx0 = (W - bw) // 2
by0 = int(W * 0.26)
bx1, by1 = bx0 + bw, by0 + bh
radius = int(bh * 0.28)

draw.rounded_rectangle([bx0, by0, bx1, by1], radius=radius, fill=(255, 255, 255))

# 气泡尾巴（左下角三角）
tail = [
    (bx0 + int(bw * 0.20), by1 - int(bh * 0.10)),
    (bx0 + int(bw * 0.12), by1 + int(bh * 0.16)),
    (bx0 + int(bw * 0.38), by1 - int(bh * 0.02)),
]
draw.polygon(tail, fill=(255, 255, 255))

# 用同色遮掉尾巴与圆角之间的小缝隙
draw.rounded_rectangle([bx0, by1 - radius, bx0 + int(bw * 0.42), by1], radius=0, fill=(255, 255, 255))

# ---------- 4. 气泡内星火（DeepSeek 火花） ----------
def star(draw_obj, cx, cy, r_out, r_in, points, fill, rot=0.0):
    pts = []
    for i in range(points * 2):
        ang = math.pi * i / points + rot - math.pi / 2
        r = r_out if i % 2 == 0 else r_in
        pts.append((cx + r * math.cos(ang), cy + r * math.sin(ang)))
    draw_obj.polygon(pts, fill=fill)

# 主星火（偏左）
star(draw, W * 0.445, W * 0.475, W * 0.105, W * 0.040, 4, "#1E60B0", rot=0.0)
# 小星火（右下）
star(draw, W * 0.565, W * 0.545, W * 0.052, W * 0.019, 4, "#3FA9F5", rot=0.0)

# ---------- 5. 降采样抗锯齿 ----------
icon = img.resize((S, S), Image.LANCZOS)

import os
out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)))
icon.save(os.path.join(out_dir, "AppIcon-1024.png"), "PNG")
print("saved:", os.path.join(out_dir, "AppIcon-1024.png"))
