{- arch-tag: Printf utilities main file
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

{- |
   Module     : MissingH.Printf
   Copyright  : Copyright (C) 2004 John Goerzen
   License    : GNU GPL, version 2 or above

   Maintainer : John Goerzen, 
   Maintainer : jgoerzen@complete.org
   Stability  : provisional
   Portability: portable

This module provides various helpful utilities for using a C-style printf().

Written by John Goerzen, jgoerzen\@complete.org
-}

module MissingH.Printf(-- * Variable-Argument Ouptut
                       vsprintf,
                       vprintf,
                       vfprintf,
                       -- * List-Argument Output
                       sprintf,
                       printf,
                       fprintf,
                       -- * Utility Function
                       v,
                       -- * Underlying Types
                       Value(..),
                       PFRun,
                       PFType(..),
                       IOPFRun,
                       ) where

import MissingH.Str
import Data.List
import System.IO
import MissingH.Printf.Types


v :: PFType a => a -> Value
v = toValue


sprintf :: String -> [Value] -> String
sprintf [] [] = []
sprintf ('%' : xs) (y : ys) = (fromValue y) ++ sprintf xs ys
sprintf ('!' : xs) (y : ys) = 
    show (((fromValue y)::Int) + 1) ++ sprintf xs ys
sprintf (x:xs) y = x : sprintf xs y

vsprintf :: (PFRun a) => String -> a
vsprintf f = pfrun $ sprintf f

fprintf :: Handle -> String -> [Value] -> IO ()
fprintf h f v = hPutStr h $ sprintf f v

printf :: String -> [Value] -> IO ()
printf f v = fprintf stdout f v

vfprintf :: IOPFRun a => Handle -> String -> a
vfprintf h f = iopfrun h $ sprintf f

vprintf :: IOPFRun a => String -> a
vprintf f = vfprintf stdout f