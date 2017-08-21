# syntax_docker

Syntaxnet
Default Environment : python2.7
Bazel Version : bazel-0.4.3

```
git clone https://github.com/TensorMSA/tensormsa_syntax_docker.git
cd tensormsa_syntax_docker
mv dockerfile_v0.1 Dokcerfile
docker build -t tylee/kor_docker .
docker run -p 9000:9000 -d tylee/kor_docker 
```
