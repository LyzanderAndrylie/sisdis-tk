FROM hyperledger/besu:latest

# Buat direktori konfigurasi di dalam /tmp atau direktori lain yang memiliki izin yang tepat
RUN mkdir -p /tmp/config

# Tulis isi file genesis.json langsung ke dalam Dockerfile
RUN echo '{ \
    "config": { \
      "berlinBlock": 0, \
      "ethash": { \
        "fixeddifficulty": 1000 \
      }, \
      "chainID": 1337 \
    }, \
    "nonce": "0x42", \
    "gasLimit": "0x1000000", \
    "difficulty": "0x10", \
    "alloc": { \
      "fe3b557e8fb62b89f4916b721be55ceb828dbd73": { \
        "privateKey": "8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63", \
        "comment": "private key and this comment are ignored.  In a real chain, the private key should NOT be stored", \
        "balance": "0xad78ebc5ac6200000" \
      }, \
      "f17f52151EbEF6C7334FAD080c5704D77216b732": { \
        "privateKey": "ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f", \
        "comment": "private key and this comment are ignored.  In a real chain, the private key should NOT be stored", \
        "balance": "90000000000000000000000" \
      } \
    } \
  }' > /tmp/config/genesis.json

ENTRYPOINT ["besu"]
