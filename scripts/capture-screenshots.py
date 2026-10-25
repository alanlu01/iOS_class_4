"""以 Debug 起始狀態擷取真正的 iOS 畫面，並等待白色啟動畫面消失。"""
import os
import pathlib
import subprocess
import sys
import tempfile
import time

root = pathlib.Path(__file__).resolve().parent.parent
os.chdir(root)
os.environ.setdefault('DEVELOPER_DIR', '/Applications/Xcode-beta.app/Contents/Developer')
device = sys.argv[1] if len(sys.argv) > 1 else '915ABEAF-A603-481F-9865-EDD735C44DF7'
bundle = 'com.alanlu01.SipAndSee'
scenes = [
    ('01-home-latte', ['-resetState']),
    ('02-citrus-filter', ['-showDrink', 'citrus', '-showFlavor', '清爽果香']),
    ('03-matcha', ['-showDrink', 'matcha', '-showFlavor', '濃郁奶香']),
    ('04-recipe', ['-showDrink', 'matcha', '-showRecipe']),
    ('05-library', ['-showTab', '1']),
    ('06-favorites', ['-showTab', '2', '-seedFavorites', 'latte,matcha']),
    ('07-empty-favorites', ['-resetState', '-showTab', '2']),
]

with tempfile.TemporaryDirectory(prefix='sip-capture-') as temporary:
    checker = str(pathlib.Path(temporary) / 'check-screen')
    subprocess.run(['swiftc', 'scripts/check-screen.swift', '-o', checker], check=True)
    for name, args in scenes:
        subprocess.run(['xcrun', 'simctl', 'terminate', device, bundle], capture_output=True)
        subprocess.run(['xcrun', 'simctl', 'launch', device, bundle] + args, check=True, capture_output=True)
        output = root / 'Deliverables' / 'screenshots' / (name + '.png')
        for attempt in range(15):
            time.sleep(3)
            subprocess.run(['xcrun', 'simctl', 'io', device, 'screenshot', str(output)], check=True, capture_output=True)
            if subprocess.run([checker, str(output)]).returncode == 0:
                # 等待啟動淡入結束，避免截到過渡畫面。
                time.sleep(3)
                subprocess.run(['xcrun', 'simctl', 'io', device, 'screenshot', str(output)], check=True, capture_output=True)
                print(name, flush=True)
                break
        else:
            raise RuntimeError('畫面尚未載入：' + name)
