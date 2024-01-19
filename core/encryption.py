import uuid
import base64
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend

class Encryption:
    """Provides functions for encrypting and decrypting values"""
    def __init__(self):
        # Generate a unique identifier for the computer
        unique_id = uuid.getnode()

        # Convert the unique identifier to bytes
        unique_id_bytes = str(unique_id).encode()

        # Use the first 16 bytes of the SHA256 hash of the unique identifier as the key
        key = hashes.Hash(hashes.SHA256(), backend=default_backend())
        key.update(unique_id_bytes)
        self.key = key.finalize()[:16]

    def encrypt_value(self, value):
        """Encrypts a value with AES-128 and returns the encrypted value as a base64-encoded string"""
        
        if value == None:
            return ""

        # Create a cipher object
        cipher = Cipher(algorithms.AES(self.key), modes.ECB(), backend=default_backend())
        encryptor = cipher.encryptor()

        # Pad the value to a multiple of the block size
        padder = padding.PKCS7(128).padder()
        padded_value = padder.update(value.encode()) + padder.finalize()

        # Encrypt the value
        encrypted_value = encryptor.update(padded_value) + encryptor.finalize()

        # Return the encrypted value as a base64-encoded string
        return base64.b64encode(encrypted_value).decode()

    def decrypt_value(self, encrypted_value):
        """Decrypts a value that was encrypted with the encrypt_value function"""

        if encrypted_value == None:
            return ""

        # Create a cipher object
        cipher = Cipher(algorithms.AES(self.key), modes.ECB(), backend=default_backend())
        decryptor = cipher.decryptor()

        # Decrypt the value
        decrypted_value = decryptor.update(base64.b64decode(encrypted_value)) + decryptor.finalize()

        # Unpad the value
        unpadder = padding.PKCS7(128).unpadder()
        unpadded_value = unpadder.update(decrypted_value) + unpadder.finalize()

        # Return the decrypted value as a string
        return unpadded_value.decode()
