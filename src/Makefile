TARGET = htmlsync
BIN_DIR = ..\bin

all: $(TARGET).exy
	exerb $(TARGET).exy
	copy $(TARGET).exe $(BIN_DIR)
	copy $(TARGET).cfg $(BIN_DIR)
	
$(TARGET).exy: $(TARGET).rb
	mkexy $(TARGET).rb

clean:
	del *.exy
	del *.exe
	del ..\bin\*.exe
	del ..\bin\*.cfg
