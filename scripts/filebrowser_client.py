from getpass import getpass
import os
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Dict
from urllib.parse import quote  # url encode e.g. quote("hello world")=hello%20world

import requests


class FileBrowserClient:
    def __init__(
            self,
            base_url: str = "http://192.168.161.132:8080",
            username: str | None = None,
            password: str | None = None
        ):
        self.base_url = base_url.rstrip("/")
        self.username = username if username else input("Username: ")
        self.password = password if password else getpass("Password: ")
        self.session = requests.Session()
        self._login()

    def _login(self):
        response = self.session.post(
            f"{self.base_url}/api/login",
            json={"username": self.username, "password": self.password},
        )
        response.raise_for_status()
        self.session.headers.update({"X-Auth": response.text.strip()})

    def list_files(self, path="/") -> Dict:
        path = quote(path, safe="/")
        response = self.session.get(f"{self.base_url}/api/resources{path}")
        return response.json()

    def upload(self, local_path: str, remote_path: str, overwrite: bool = False):
        """若無資料夾會自動建立"""
        local_file = Path(local_path)
        if not local_file.exists():
            raise FileNotFoundError(local_file)

        remote_path = "/" + remote_path.lstrip("/")
        remote_path = quote(remote_path, safe="/")
        url = (
            f"{self.base_url}/api/resources"
            f"{remote_path}"
            f"?override={'true' if overwrite else 'false'}"
        )

        with open(local_file, "rb") as f:
            response = self.session.post(
                url,
                data=f,
                headers={
                    "Content-Type": "application/octet-stream"
                }
            )

    def download(self, remote_path: str, local_file: str):
        remote_path = "/" + remote_path.lstrip("/")
        remote_path = quote(remote_path, safe="/")

        response = self.session.get(
            f"{self.base_url}/api/raw{remote_path}",
            stream=True
        )
        local_file = Path(local_file)

        with open(local_file, "wb") as f:
            for chunk in response.iter_content(chunk_size=1024 * 1024):
                if chunk:
                    f.write(chunk)

    def delete(self, remote_path: str):
        """可刪除整個資料夾"""
        remote_path = "/" + remote_path.lstrip("/")
        remote_path = quote(remote_path, safe="/")

        response = self.session.delete(
            f"{self.base_url}/api/resources{remote_path}"
        )


if __name__ == "__main__":
    obj = FileBrowserClient()

    print(obj.list_files())
    """
    {'items': [], 'numDirs': 0, 'numFiles': 0, 'sorting': {'by': 'name', 'asc': False}, 'path': '/', 'name': '', 'size': 4096, 'extension': '.chao', 'modified': '2026-09-22T03:48:21.5Z', 'mode': 2147484141, 'isDir': True, 'isSymlink': False, 'type': ''}
    """

    obj.upload("/app/scripts/filebrowser_client.py", "filebrowser_client.py")
    print(obj.list_files())
    """
    {'items': [{'path': '/filebrowser_client.py', 'name': 'filebrowser_client.py', 'size': 2967, 'extension': '.py', 'modified': '2026-09-22T03:47:43.106Z', 'mode': 416, 'isDir': False, 'isSymlink': False, 'type': 'text'}], 'numDirs': 0, 'numFiles': 1, 'sorting': {'by': 'name', 'asc': False}, 'path': '/', 'name': '', 'size': 4096, 'extension': '.chao', 'modified': '2026-09-22T03:47:43.106Z', 'mode': 2147484141, 'isDir': True, 'isSymlink': False, 'type': ''}
    """

    with TemporaryDirectory() as tmpdir:
        obj.download("filebrowser_client.py", f"{tmpdir}/filebrowser_client_downloaded.py")
        assert os.path.exists(f"{tmpdir}/filebrowser_client_downloaded.py")

    obj.delete("filebrowser_client.py")
    print(obj.list_files())
    """
    {'items': [], 'numDirs': 0, 'numFiles': 0, 'sorting': {'by': 'name', 'asc': False}, 'path': '/', 'name': '', 'size': 4096, 'extension': '.chao', 'modified': '2026-09-22T03:48:21.5Z', 'mode': 2147484141, 'isDir': True, 'isSymlink': False, 'type': ''}
    """
