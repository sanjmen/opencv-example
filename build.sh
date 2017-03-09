
PROJECT_ROOT=`pwd`
APP_PATH=${PROJECT_ROOT}/app
PYTHON_VERSION=3.6.0
ENV_NAME=opencv_env-${PYTHON_VERSION}

# create virtualenv
echo "creating virtualenv"
pyenv virtualenv ${PYTHON_VERSION} ${ENV_NAME}
touch .python-version
echo ENV_NAME > .python-version
pyenv local ${ENV_NAME}

PREFIX=`pyenv prefix`
PREFIX_MAIN=`pyenv virtualenv-prefix`

echo "installing requirements"
cd ${APP_PATH}
pip install -r requirements.txt
cd ${PROJECT_ROOT}

echo "clone opencv repository"
git clone https://github.com/opencv/opencv.git
cd opencv
mkdir build
cd build

echo "configure and build opencv"

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D PYTHON3_EXECUTABLE=${PREFIX}/bin/python3 \
    -D PYTHON3_PACKAGES_PATH=${PREFIX}/lib/python3.6/site-packages \
    -D PYTHON3_LIBRARY=${PREFIX_MAIN}/lib/libpython3.6m.a \
    -D PYTHON3_INCLUDE_DIR=${PREFIX_MAIN}/include/python3.6m \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=${PREFIX}/lib/python3.6/site-packages/numpy/core/include \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D BUILD_EXAMPLES=ON \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_NAME_DIR=${CMAKE_INSTALL_PREFIX}/lib ..

NUMBER_OF_CORES=`sysctl -n hw.ncpu`
make -j${NUMBER_OF_CORES}
make install

echo "DONE. opencv3 installed!"

echo "test your configuration running: python -c 'import cv2; print(cv2.__version__)'"
