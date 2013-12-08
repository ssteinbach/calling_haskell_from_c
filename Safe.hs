{-# LANGUAGE ForeignFunctionInterface #-}
 
module Safe where
 
import Foreign.C.Types
 
fibonacci :: Int -> Int
fibonacci n = fibs !! n
    where fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
 
-- wrapper code - I think it might be possible to autogenerate this?
fibonacci_hs :: CInt -> CInt
fibonacci_hs = fromIntegral . fibonacci . fromIntegral
 
foreign export ccall fibonacci_hs :: CInt -> CInt
