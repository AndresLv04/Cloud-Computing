#!/bin/bash
set -euo pipefail

# ===== Vars inyectadas por templatefile =====
BUCKET_NAME="${bucket_name}"
AWS_REGION="${region}"

# ===== Paquetes base (AL2023 usa dnf, AL2 usa yum) =====
if command -v dnf >/dev/null 2>&1; then
  dnf -y update
  dnf -y install python3 python3-pip
else
  yum -y update
  yum -y install python3 python3-pip
fi

# ===== Ajuste de pip solo para Python 3.7 (AL2) =====
PYVER="$(python3 -c 'import sys; print("{}.{}".format(sys.version_info[0], sys.version_info[1]))')"
if [ "$PYVER" = "3.7" ]; then
  python3 -m pip install --upgrade "pip<24" || true
fi

# ===== App =====
mkdir -p /opt/app/templates

cat >/opt/app/requirements.txt <<'EOT'
Flask==2.2.5
gunicorn==20.1.0
boto3==1.34.0
python-dotenv==0.21.1
EOT

python3 -m pip install -r /opt/app/requirements.txt

cat >/opt/app/.env <<EOT
BUCKET_NAME=${bucket_name}
AWS_REGION=${region}
EOT

cat >/opt/app/templates/index.html <<'EOT'
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>S3 Uploader</title></head>
<body>
  <h1>Subir archivos a S3</h1>
  <form action="/upload" method="post" enctype="multipart/form-data">
    <!-- name=photo y multiple para que el backend los lea con getlist("photo") -->
    <input type="file" name="photo" multiple required>
    <button type="submit">Subir</button>
  </form>
  <div>{{ message|safe }}</div>
</body></html>
EOT


cat >/opt/app/app.py <<'EOT'
import os, uuid, botocore
from flask import Flask, request, render_template
from werkzeug.utils import secure_filename
import boto3

app = Flask(__name__)

BUCKET = os.getenv("BUCKET_NAME")
REGION = os.getenv("AWS_REGION", "us-east-1")
ALLOWED = {"png","jpg","jpeg","gif","webp","pdf","txt","zip","mp4"}

s3 = boto3.client("s3", region_name=REGION)

def allowed(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED

@app.get("/")
def index():
    return render_template("index.html", message="")

@app.post("/upload")
def upload():
    try:
        files = request.files.getlist("photo")  # <- leemos todos
        # nada seleccionado
        if not files or all(f.filename == "" for f in files):
            return render_template("index.html", message="⚠️ No seleccionaste ningún archivo.")

        uploaded = 0
        skipped = []
        for f in files:
            if not f or f.filename == "":
                continue
            if not allowed(f.filename):
                skipped.append(secure_filename(f.filename))
                continue

            key = f"uploads/{uuid.uuid4()}-{secure_filename(f.filename)}"
            s3.upload_fileobj(
                f, BUCKET, key,
                ExtraArgs={"ContentType": f.mimetype}
            )
            uploaded += 1

        if uploaded == 0:
            return render_template("index.html", message="❌ Ningún archivo válido para subir.")

        msg = f"✅ {uploaded} archivo(s) subido(s) correctamente."
        if skipped:
            msg += " ⛔ Omitidos (tipo no permitido): " + ", ".join(skipped)
        return render_template("index.html", message=msg)

    except botocore.exceptions.ClientError as e:
        code = e.response['Error'].get('Code', 'Desconocido')
        return render_template("index.html", message=f"❌ Error al subir: {code}")
    except Exception as e:
        return render_template("index.html", message=f"❌ Error inesperado: {str(e)}")

@app.get("/health")
def health():
    return {"status":"ok","bucket":BUCKET}, 200
EOT


cat >/etc/systemd/system/photo-uploader.service <<'EOT'
[Unit]
Description=Photo Uploader Flask App
After=network.target

[Service]
User=root
WorkingDirectory=/opt/app
EnvironmentFile=/opt/app/.env
Environment="PYTHONUNBUFFERED=1"
ExecStart=/usr/bin/python3 -m gunicorn -w 2 -b 0.0.0.0:80 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# Activar servicio
systemctl daemon-reload
systemctl enable photo-uploader
systemctl restart photo-uploader

# Marca de fin
echo "User-data finished at $(date)" >> /var/log/user-data-done.log